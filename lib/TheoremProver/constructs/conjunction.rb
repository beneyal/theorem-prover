require_relative 'binary_op'

class Conjunction < BinaryOp
  def accept(visitor)
    visitor.visit_conjunction self
  end

  def to_s
    "(#{left} /\\ #{right})"
  end
end