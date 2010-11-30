module OrbitalCommand
		class Config
				attr_accessor :routers, :scan_file, :image_file, :default_gateway
				
				def initialize
						self.routers = []
						self.image_file = 'scan.png'
						self.scan_file = 'scan.xml'
				end

				def load_yaml_file file
					config_file = YAML.parse_file(file)
					self.routers = config_file['routers'].value.collect do |x|
							values = {}
							x.value.each { |x,y| values[x.value.to_sym] = y.value.to_s }
							values
					end
					self.default_gateway = config_file['default_gateway'].value if config_file['default_gateway']
				end
		end
end
