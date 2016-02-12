require_relative 'abstract_construct'

class Negation < AbstractConstruct
  attr_reader :formula
  def initialize(formula)
    @formula = formula
  end

  def accept(visitor)
    visitor.visit_negation self
  end

  def to_s
    "(not #{formula})"
  end

  protected

  def state
    [@formula]
  end
end