require_relative 'binary_op'

module FirstOrderLogic
  class Implication < BinaryOp
    def accept(visitor)
      visitor.visit_implication self
    end

    protected

    def symbol
      "\u2192"
    end
  end
end