module OrbitalCommand
		class Scan
				def initialize
						return if File.exists? 'scan.xml'
						puts "Running nmap scan...."
						Nmap::Program.scan do |nmap|
								nmap.sudo = true

								nmap.syn_scan = true
								nmap.service_scan = true
								nmap.os_fingerprint = true
								nmap.xml = 'scan.xml'
								nmap.verbose = true

								nmap.ports = [20,21,22,23,25,80,110,443,512,522,8080,1080]
								nmap.targets = '192.168.0.*'
						end
				end

				def hosts
						x = Nmap::XML.new('scan.xml')
						x.each do |x| 
								puts x
						end
				end
		end
end
