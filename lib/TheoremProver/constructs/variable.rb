require_relative 'negation'

class Variable
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def accept(visitor)
    visitor.visit_variable self
  end

  def to_s
    name
  end
end