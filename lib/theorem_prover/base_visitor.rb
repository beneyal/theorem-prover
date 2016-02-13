Dir[File.join(File.dirname(__FILE__), '../first_order_logic', '*.rb')].each { |f| require f }

class BaseVisitor
  def visit_biconditional(formula)
    FirstOrderLogic::Biconditional.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_implication(formula)
    FirstOrderLogic::Implication.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_negation(formula)
    FirstOrderLogic::Negation.new(formula.formula.accept(self))
  end

  def visit_universal(formula)
    FirstOrderLogic::Universal.new(formula.variables, formula.formula.accept(self))
  end

  def visit_existential(formula)
    FirstOrderLogic::Existential.new(formula.variables, formula.formula.accept(self))
  end

  def visit_disjunction(formula)
    FirstOrderLogic::Disjunction.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_conjunction(formula)
    FirstOrderLogic::Conjunction.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_equality(equality)
    FirstOrderLogic::Equality.new(equality.lhs.accept(self), equality.rhs.accept(self))
  end

  def visit_predicate(predicate)
    predicate
  end

  def visit_function(function)
    function
  end

  def visit_variable(variable)
    variable
  end

  def visit_constant(constant)
    constant
  end
end
