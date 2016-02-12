require_relative 'abstract_construct'

class Equality < AbstractConstruct
  attr_reader :lhs, :rhs
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def accept(visitor)
    visitor.visit_equality self
  end

  def to_s
    "(= #{lhs} #{rhs})"
  end

  protected

  def state
    [@lhs, @rhs]
  end
end