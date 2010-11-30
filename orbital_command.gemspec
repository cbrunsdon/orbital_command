require 'rake'

spec = Gem::Specification.new do |s|
		s.name = 'orbital_command'
		s.version = '0.1.3'
		s.summary = "Scan's the network using sophsec's ruby-nmap and prints our a graph using graphviz"
		s.author = "Clarke Brunsdon"
		s.email = "clarke@freerunningtechnologies.com"
		s.homepage = "http://clarkebrunsdon.com"

		s.test_files = Dir['test/*']

		s.bindir = "bin"
		s.executables << "scan"

		s.add_dependency('ifestor')
		s.add_dependency('nokogiri')
		s.add_dependency('mechanize')
		s.add_dependency('ruby-nmap')
		s.add_dependency('ruby-graphviz')

		s.files = ["lib/orbital_command.rb", "lib/orbital_command/*.rb", "README.md", "LICENSE.txt"]

		s.files = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/*'].to_a
end
