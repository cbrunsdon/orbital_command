module OrbitalCommand
		class Router < OrbitalCommand::Host
				attr_accessor :hosts
				def initialize  nmap_host, router={}
					super(nmap_host)
					self.hosts = []
				end

				def self.parse_router router, nmap_host
						case router[:type]
						when 'dlink':
								return OrbitalCommand::Routers::Dlink.new nmap_host, router
						when 'ddwrt':
								return OrbitalCommand::Routers::DDWrt.new nmap_host, router
						else 
								return OrbitalCommand::Router.new nmap_host, router
						end
				end

				def import_hosts hosts
						hosts.each do |host|
								self.hosts.push host if self.host_attached? host
						end
				end

				def host_attached? host
						false #expected to be overridden by children
				end
		end
end
