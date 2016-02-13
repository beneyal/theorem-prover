require_relative 'binary_op'

module FirstOrderLogic
  class Conjunction < BinaryOp
    def accept(visitor)
      visitor.visit_conjunction self
    end

    protected

    def symbol
      "\u2227"
    end
  end
end