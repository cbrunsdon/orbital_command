gem 'mechanize'
require 'mechanize'
require 'rexml/document'

module OrbitalCommand
		module Routers
				class DefaultGateway < OrbitalCommand::Router
						def initialize(nmap_host)
								super(nmap_host)
						end

						def host_attached? host
								hosts.include? host
						end

						def header_color
								return "red"
						end
				end
		end
end
