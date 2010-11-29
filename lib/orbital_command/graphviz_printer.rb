require 'rubygems'
require 'graphviz'

module OrbitalCommand
  class GraphVizPrinter
    def initialize
      @g = GraphViz::new(:G, :type => :graph, :rankdir => "LR")
    end
		def import_host host
      @g.add_node(host.name, :label => host.graph_table, :shape => "Mrecord")
		end
    def add_edge(s, t)
      @g.add_edge(s, t)
    end
    def output filename
      @g.output(:png => filename, :use => 'circo')
    end
  end
end

