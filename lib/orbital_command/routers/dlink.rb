gem 'mechanize'
require 'mechanize'
require 'rexml/document'

module OrbitalCommand
		module Routers
				class Dlink < OrbitalCommand::Router
						def initialize(router, nmap_host)
								super(router, nmap_host)

								agent = Mechanize.new

								@nodes = []

								router_path = "http://#{router[:ip]}"
								login_path = "#{router_path}/post_login.xml?hash=#{router[:password]}"
								x = agent.get(login_path)
								clients_xml = agent.get("#{router_path}/wifi_assoc.xml").body
								wifi_clients = REXML::Document.new(clients_xml)
								wifi_clients.elements.each('//assoc') do |assoc|
										@nodes.push( { :channel => assoc.elements['channel'][0],
															 :mac => assoc.elements['mac'][0],
															 :ip => assoc.elements['ip_address'][0],
															 :quality => assoc.elements['quality'][0],
															 :rate => assoc.elements['rate'][0] } )
								end

						end

						def host_attached? host
								host_mac = host.mac.gsub(/:/, '')
								@nodes.any? { |x| x[:mac] == host_mac }
						end
				end
		end
end
