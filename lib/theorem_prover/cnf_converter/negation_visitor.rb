require_relative 'cnf_converter'
require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../first_order_logic', '*.rb')].each do |f|
  require f
end

class CNFConverter
  class NegationVisitor < BaseVisitor
    def visit_negation(formula)
      @negated = !negated?
      formula.formula.accept(self)
    end

    def visit_universal(formula)
      if negated?
        @negated = false
        FirstOrderLogic::Existential.new(formula.variables,
                        FirstOrderLogic::Negation.new(formula.formula).accept(self))
      else
        super(formula)
      end
    end

    def visit_existential(formula)
      if negated?
        @negated = false
        FirstOrderLogic::Universal.new(formula.variables,
                                       FirstOrderLogic::Negation.new(formula.formula).accept(self))
      else
        super(formula)
      end
    end

    def visit_disjunction(formula)
      if negated?
        @negated = false
        FirstOrderLogic::Conjunction.new(FirstOrderLogic::Negation.new(formula.left).accept(self),
                                         FirstOrderLogic::Negation.new(formula.right).accept(self))
      else
        super(formula)
      end
    end

    def visit_conjunction(formula)
      if negated?
        @negated = false
        FirstOrderLogic::Disjunction.new(FirstOrderLogic::Negation.new(formula.left).accept(self),
                                         FirstOrderLogic::Negation.new(formula.right).accept(self))
      else
        super(formula)
      end
    end

    def visit_predicate(predicate)
      negate_atom(predicate)
    end

    def visit_function(function)
      negate_atom(function)
    end

    def visit_constant(constant)
      negate_atom(constant)
    end


    private

    attr_reader :negated
    alias_method :negated?, :negated

    def negate_atom(atom)
      if negated?
        @negated = false
        FirstOrderLogic::Negation.new(atom)
      else
        atom
      end
    end
  end
end