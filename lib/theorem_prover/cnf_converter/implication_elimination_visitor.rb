require_relative 'base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each { |f| require f }

class ImplicationEliminationVisitor < BaseVisitor
  def visit_biconditional(formula)
    left = formula.left.accept self
    right = formula.right.accept self
    Conjunction.new(Implication.new(left, right).accept(self), Implication.new(right, left).accept(self))
  end

  def visit_implication(formula)
    left = formula.left.accept self
    right = formula.right.accept self
    Disjunction.new(Negation.new(left), right)
  end
end
