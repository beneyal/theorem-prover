require_relative 'binary_op'
require_relative 'conjunction'
require_relative 'negation'

class Disjunction < BinaryOp
  def accept(visitor)
    visitor.visit_disjunction self
  end

  def to_s
    "(#{left} \\/ #{right})"
  end
end