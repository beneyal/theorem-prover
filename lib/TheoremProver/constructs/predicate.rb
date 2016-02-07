require_relative 'negation'

class Predicate
  attr_reader :name, :terms
  def initialize(name, terms)
    @name = name
    @terms = terms
  end

  def accept(visitor)
    visitor.visit_predicate self
  end

  def to_s
    "#{name}(#{terms.join(', ')})"
  end
end