require_relative 'binary_op'

class Implication < BinaryOp
  def accept(visitor)
    visitor.visit_implication self
  end

  def to_s
    "(#{left} -> #{right})"
  end
end