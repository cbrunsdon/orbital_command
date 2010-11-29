require 'rubygems'
require 'graphviz'

module OrbitalCommand
  class GraphVizPrinter
    def initialize
      @g = GraphViz::new(:G, :type => :graph, :rankdir => "LR")
    end
		def import_host host
				self.add_host(:hostname => host.hostname, :ip => host.ip, :mac => host.mac, :os => host.os_name)
		end
    def add_host options
      name = options[:hostname] || options[:ip]
      data = []
      data << options.delete(:ip)
      data << ("ports: " << options.delete(:ports).join(', ')) if options[:ports]
      data << options.delete(:mac)
			os = options.delete(:os)
			# split up OS on to two lines if its Long
			if os.length > 30
					os.insert((os.index(";") || os.index("(") || os.index(" ", 20)), "<br />")
			end
      data << os
      data.compact!
      s = '<<table cellpadding="0" cellspacing="0">'

      s += '<tr><td bgcolor="grey">' + name + '</td></tr>'
      data.each do |datum|
        s += '<tr><td>'
        s += datum
        s += '</td></tr>'
      end
      s += '</table>>'
      @g.add_node(name, :label => s, :shape => "Mrecord")
    end
    def add_edge(s, t)
      @g.add_edge(s, t)
    end
    def output filename
      @g.output(:png => filename, :use => 'circo')
    end
  end
end

if __FILE__ == $0
  g = OrbitalCommand::GraphVizPrinter.new

  r1 = g.add_host(:ip => '192.168.0.3', :mac => '00:22:B0:B1:DF:5E', :os => 'D-Link embedded')
  r2 = g.add_host(:ip => '192.168.0.4', :mac => '00:14:BF:4B:14:43', :os => 'Linux 2.4.X')

  dragoon = g.add_host(:hostname => 'dragoon', :os => 'Linux 2.6.X', :ports => [22, 53, 111, 667, 49152], :mac => '00:50:ba:45:1f:d7')
  probe   = g.add_host(:hostname => 'probe')
  stalker = g.add_host(:hostname => 'stalker')
  ricky   = g.add_host(:hostname => 'ricky', :mac => '00:23:14:AC:67:14', :ip => '192.168.0.60', :os => 'Linux 2.6.X')

  g.add_edge(dragoon, r1)
  g.add_edge(r1, r2)
  g.add_edge(r2, probe)
  g.add_edge(r2, stalker)
  g.add_edge(r1, ricky)

  g.output('test.png')
end

