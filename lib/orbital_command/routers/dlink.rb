gem 'mechanize'
require 'mechanize'
require 'rexml/document'
require 'digest/md5'
require 'nokogiri'

module OrbitalCommand
		module Routers
				class Dlink < OrbitalCommand::Router
						def initialize(nmap_host, router)
								super(nmap_host, router)

								agent = Mechanize.new

								@nodes = []

								router_path = "http://#{router[:ip]}"
								x = agent.get(router_path)
								salt = x.body.match(/salt = "(.*)"/)[1]

								# pad the pasword to length 16
								pad_size = (16 - router[:password].length)
								padded_password = router[:password] + "\x01" * pad_size

								# pad it the rest of the way, length 64 for admin
								salted_password = salt + padded_password + ("\x01" * (64 - salt.length - padded_password.length))
								login_hash = salt + Digest::MD5.hexdigest(salted_password)

								login_path = "#{router_path}/post_login.xml?hash=#{login_hash}"

								x = agent.get(login_path)
								clients_xml = agent.get("#{router_path}/wifi_assoc.xml").body
								doc = Nokogiri::XML(clients_xml.to_s)
								doc.xpath('//assoc').each do |assoc|
										children = assoc.children
										@nodes.push( { :channel => children.search('channel')[0].text,
															 :mac => children.search('mac')[0].text,
															 :ip => children.search('ip_address')[0].text,
															 :quality => children.search('quality')[0].text,
															 :rate => children.search('rate')[0].text } )
								end

						end

						def host_attached? host
								host_mac = host.mac.gsub(/:/, '')
								@nodes.any? { |x| x[:mac] == host_mac }
						end
				end
		end
end
