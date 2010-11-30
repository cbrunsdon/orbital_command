require 'nmap/program'
require 'nmap/xml'
require 'ifestor'

module OrbitalCommand
		class Scan
				def initialize config
						@config = config

						run_nmap unless File.exists? @config.scan_file
						hosts

						raise "Couldn't figure out the default gateway" unless default_gateway_ip

						# add the stray hosts to the default gateway
						default_gateway.hosts = stray_hosts
				end

				def hosts
						return @hosts if @hosts

						@hosts = Nmap::XML.new(@config.scan_file).collect { |x| parse_host(x) }
				end

				def routers
						return @routers if @routers

						@routers = hosts.each.select { |x| x.is_a? Router }
						@routers.each { |x| x.import_hosts hosts }
				end

				def parse_host nmap_host
						matching_router = @config.routers.detect { |x| x[:ip] == nmap_host.ip }
						
						if matching_router
								host = OrbitalCommand::Router.parse_router matching_router, nmap_host
						elsif nmap_host.ip == default_gateway_ip #might not be a router we control, but still our default gateway
								host = OrbitalCommand::Routers::DefaultGateway.new nmap_host
						else
								host = OrbitalCommand::Host.new nmap_host
						end
						
						# nmap leaves the current host without a mac address in our scan.
						# to get it, we'll need to check our interfaces and update the host
						if host.mac.nil?
								host.mac = my_mac_address(host.ip).upcase
								raise "Couldn't figure out our mac address, had ip: #{host.ip} ..." unless host.mac
						end

						host
				end

				def run_nmap
						puts "Running nmap scan...."
						Nmap::Program.scan do |nmap|
								nmap.sudo = true

								nmap.syn_scan = true
								nmap.service_scan = true
								nmap.os_fingerprint = true
								nmap.xml = @config.scan_file
								nmap.enable_dns = true
								nmap.verbose = false #nmap.verbose = true
								#nmap.traceroute = true

								nmap.ports = [20,21,22,23,25,80] #,110,443,512,522,8080,1080]
								
								nmap.targets = default_gateway_ip.gsub /.\d*$/, '.*'
						end
				end

				def print_graph
						g = OrbitalCommand::GraphVizPrinter.new

						router_nodes = []
						# first make each router, and add all its hosts
						self.routers.each do |router|
								node = g.import_host router
								router_nodes.push node

								# now we add all its children...
								router.hosts.each do |host|
										host_node = g.import_host host
										g.add_edge node, host_node
								end
						end

						# now we go through and connect the routers...
						for i in 0..(router_nodes.length - 1)
								for k in (i+1)..(router_nodes.length() - 1)
										g.add_edge router_nodes[i], router_nodes[k]
								end
						end
						
						g.output(@config.image_file)
				end

				def stray_hosts
						hosts.select { |host| !host_is_attached_to_a_router(host) && !host.is_a?(Router) }
				end

				def host_is_attached_to_a_router host
					routers.any? { |router| router.host_attached? host } 
				end

				def default_gateway_ip
						@gateway_ip ||= @config.default_gateway || (`route -n`.split("\n").last.match /\s[\d\.]+/)[0].strip
				end

				def default_gateway 
						routers.detect { |x| x.is_a? OrbitalCommand::Routers::DefaultGateway }
				end

				def my_mac_address ip
						Ifestor.interfaces.detect { |x| x[:ip] == ip }[:mac]
				end

		end
end
