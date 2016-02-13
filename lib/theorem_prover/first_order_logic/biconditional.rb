require_relative 'binary_op'

module FirstOrderLogic
  class Biconditional < BinaryOp
    def accept(visitor)
      visitor.visit_biconditional self
    end

    protected

    def symbol
      "\u2194"
    end
  end
end