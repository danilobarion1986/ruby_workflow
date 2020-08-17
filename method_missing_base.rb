module MethodMissingBase
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def method_missing(m, *args, &block)
    puts "caller:#{self} | method:##{m} | class:#{self.class.name} | args:#{args}"
    return block.call(self) if block_given?
    self
  end

  module ClassMethods
    def method_missing(m, *args, &block)
      puts "caller:#{self} | method:##{m} | class:#{self} | args:#{args}"
      return block.call(self) if block_given?
      self
    end
  end
end
