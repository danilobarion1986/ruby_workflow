require 'ast'

class AstProcessor
  include AST::Processor::Mixin

  def on_send(node)
    puts "=================== on_send"
    node.children.each do |child|
      case child
      when Integer
        puts child
      when NilClass
        puts 'nil'
      when String
        puts "\"#{child}\""
      when Symbol
        puts ":#{child}"
      when Parser::AST::Node
        process(child)
      else
        puts child.type.to_s
      end
    end
  end

  def handler_missing(node)
    nil
  end
end
