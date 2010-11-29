gem 'mechanize'
require 'mechanize'
require 'nokogiri'

module OrbitalCommand
		module Routers
				class DDWrt < OrbitalCommand::Router
						def initialize(nmap_host, router)
								super(nmap_host, router)

								agent = Mechanize.new
								agent.basic_auth(router[:username], router[:password])
								
								router_path = "http://#{router[:ip]}"
								wireless_path = "#{router_path}/Status_Wireless.asp"
								x = agent.get(wireless_path)

								table_call = (x.body.match /setWirelessTable\((.*)\);/)[1]

								@nodes = parse_wireless_table_call table_call
						end

						def parse_wireless_table_call table_call
								node_list = []
								table_call.gsub! /'/, ''
								values = table_call.split ','
								# the format is mac,interface,uptime,tx,rx,signal,noise,snr,something
								while !values.empty?
										node = values.slice!(0, 9)
										node_list.push( { :mac => node[0].gsub(/:/, ''), :quality => node[5] } )
								end
								node_list
						end

						def host_attached? host
								host_mac = host.mac.gsub(/:/, '')
								@nodes.any? { |x| x[:mac] == host_mac }
						end
				end
		end
end
