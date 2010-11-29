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

				def name
						hostname || ip
				end

				def graph_table
						data = []


						#data << ("ports: " << options.delete(:ports).join(', ')) if options[:ports]
						data << mac
						os = os_name
						# split up OS on to two lines if its Long
						if os.length > 30
								os.insert((os.index(";") || os.index("(") || os.index(" ", 20)), "<br />")
						end
						data << os
						data.compact!

						s = '<<table cellpadding="0" cellspacing="0">'
						s += "<tr><td bgcolor='#{self.header_color}'><font point-size='#{header_size}'>#{name}</font></td></tr>"
						data.each do |datum|
								s += '<tr><td>'
								s += datum
								s += '</td></tr>'
						end
						s += '</table>>'

				end

				def header_color 
						"grey"
				end

				def header_size
						15
				end
		end
end
