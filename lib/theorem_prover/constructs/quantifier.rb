require_relative 'abstract_construct'

class Quantifier < AbstractConstruct
  attr_reader :variables, :formula
  def initialize(variables, formula)
    @variables = variables
    @formula = formula
  end

  protected

  def state
    [@variables, @formula]
  end
end