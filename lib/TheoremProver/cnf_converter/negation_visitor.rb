require_relative 'base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each { |f| require f }

class NegationVisitor < BaseVisitor
  def initialize
    @env = []
  end

  def visit_biconditional(_formula)
    fail
  end

  def visit_implication(_formula)
    fail
  end

  def visit_negation(formula)
    # wtf?
  end

  def visit_universal(formula)
    Existential.new(formula.variables,
                    Negation.new(formula.formula.accept(self)))
  end

  def visit_existential(formula)
    Universal.new(formula.variables,
                  Negation.new(formula.formula.accept(self)))
  end

  def visit_equality(equality)
    Negation.new(equality)
  end

  def visit_disjunction(formula)
    Conjunction.new(Negation.new(formula.left.accept(self)),
                    Negation.new(formula.right.accept(self)))
  end

  def visit_conjunction(formula)
    Disjunction.new(Negation.new(formula.left.accept(self)),
                    Negation.new(formula.right.accept(self)))
  end
end
