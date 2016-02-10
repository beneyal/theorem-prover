class Negation
  attr_reader :formula
  def initialize(formula)
    @formula = formula
  end

  def accept(visitor)
    visitor.visit_negation self
  end

  def to_s
    "~(#{formula})"
  end
end