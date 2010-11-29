module OrbitalCommand
		class Config
				attr_accessor :routers, :scan_file, :image_file
				
				def initialize
						self.routers = []
						self.image_file = 'scan.png'
				end

				def load_yaml_file file
					config_file = YAML.parse_file(file)
					self.routers = config_file['routers'].value.collect do |x|
							values = {}
							x.value.each { |x,y| values[x.value.to_sym] = y.value.to_s }
							values
					end
				end
		end
end
