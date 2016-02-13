require_relative 'term'

class Variable < Term
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

  protected

  def state
    [@name]
  end
end