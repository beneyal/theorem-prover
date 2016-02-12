require_relative 'binary_op'

class Disjunction < BinaryOp
  def accept(visitor)
    visitor.visit_disjunction self
  end

  def to_s
    "(or #{left} #{right})"
  end
end