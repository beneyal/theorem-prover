require_relative 'negation'

class Quantifier
  attr_reader :variables, :formula
  def initialize(variables, formula)
    @variables = variables
    @formula = formula
  end
end