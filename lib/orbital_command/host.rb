module OrbitalCommand

		class Host

				attr_accessor :status, :ip, :mac, :os_matches, :os_classes, :open_ports, :hostname
				def initialize nmap_host
						self.hostname = nmap_host.hostnames.first
						self.status = nmap_host.status
						self.ip = nmap_host.ip 
						self.mac = nmap_host.mac 
						self.os_matches = nmap_host.os.matches
						self.os_classes = nmap_host.os.classes

						#self.open_ports = nmap_host.open_ports 
				end

				def os_name
						return os_matches.any? ? os_matches.last.name : best_os_class
				end

				def best_os_class
						return "" if os_classes.empty?
						"#{os_classes[0].family} - #{os_classes[0].vendor} - #{os_classes[0].type}"
				end

		end
end
