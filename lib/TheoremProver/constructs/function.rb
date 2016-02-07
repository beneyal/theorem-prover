require_relative 'negation'

class Function
  attr_reader :name, :terms
  def initialize(name, terms)
    @name = name
    @terms = terms
  end

  def accept(visitor)
    visitor.visit_function self
  end

  def to_s
    "#{name}(#{terms.join(',')})"
  end
end