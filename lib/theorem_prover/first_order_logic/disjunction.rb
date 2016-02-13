require_relative 'binary_op'

module FirstOrderLogic
  class Disjunction < BinaryOp
    def accept(visitor)
      visitor.visit_disjunction self
    end

    protected

    def symbol
      "\u2228"
    end
  end
end