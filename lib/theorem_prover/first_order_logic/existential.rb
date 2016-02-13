require_relative 'quantifier'

module FirstOrderLogic
  class Existential < Quantifier
    def accept(visitor)
      visitor.visit_existential self
    end

    protected

    def symbol
      "\u2203"
    end
  end
end