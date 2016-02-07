require_relative 'binary_op'

class Biconditional < BinaryOp
  def accept(visitor)
    visitor.visit_biconditional self
  end

  def to_s
    "(#{left} <=> #{right})"
  end
end