require_relative 'abstract_construct'

class Predicate < AbstractConstruct
  attr_reader :name, :terms
  def initialize(name, terms)
    @name = name
    @terms = terms
  end

  def accept(visitor)
    visitor.visit_predicate self
  end

  def to_s
    "(#{name} #{terms.join(' ')})"
  end

  protected

  def state
    [@name, @terms]
  end
end