require_relative './ast_processor'

class Core
  attr_reader :node_types, :graph

  def initialize(ast)
    @node_id = 0
    @ast = ast
    @node_types = []
    @graph = ::Graphviz::Graph.new
  end

  def expected
    g = ::Graphviz::Graph.new(:G, :type => :digraph)

    hello = g.add_nodes( "sadsda" )
    world = g.add_nodes( "esperasdasdasdado" )

    g.add_edges(hello, world)
    g
  end

  def poc
    processed_ast = AstProcessor.new.process(@ast)

    # Create a new graph
    # ::Graphviz::Graph.new(:G, type: :digraph ) { |g|
      create_poc(@ast)
    # }
  end

  def create_poc(current_node)
    @node_types << current_node.type

    self_node = @graph.add_node(fetch_node_id(current_node), label: current_node.type)

    # current_node is always a Parser::AST::Node
    current_node.children.each do |child|
      next if child.nil?

      if child.is_a?(Parser::AST::Node) && child.type.to_s == 'lvasgn'
        handle_left_var_assign(child)
      end

      label = case child
              when Integer; child
              when NilClass; 'nil'
              when String; "\"#{child}\""
              when Symbol; ":#{child}"
              else
                child.type.to_s
              end

      self_node.add_node(fetch_node_id(child), label: label)

      create_poc(child) if child.respond_to?(:children)
    end
  end

  def handle_left_var_assign(node)
    binding.pry
    @graph.add_node(node.type.to_s, shape: 'box3d')
  end

  # def visualize
  #   # Graphviz::Graph.new
  #   ::GraphViz.new(:G, type: :digraph) {|g|
  #     reconfigure(g, @ast)
  #   }
  # end

  private

  # def reconfigure(g, node)
  #   self_node = g.add_nodes(fetch_node_id(node), label: node.type)

  #   node.children.each {|child|
  #     label = case child
  #             when Integer; child
  #             when NilClass; 'nil'
  #             when String; "\"#{child}\""
  #             when Symbol; ":#{child}"
  #             else
  #               child.type.to_s
  #             end

  #     self_node << g.add_nodes(fetch_node_id(child), label: label)

  #     reconfigure(g, child) if child.respond_to? :children
  #   }
  # end

  def fetch_node_id(node)
    case node
    when Integer, NilClass, String, Symbol
      (@node_id += 1).to_s
    else
      node.object_id.to_s
    end
  end
end

