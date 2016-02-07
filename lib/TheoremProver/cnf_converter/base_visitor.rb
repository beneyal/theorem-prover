Dir['./TheoremProver/constructs/*.rb'].each { |f| require f }
class BaseVisitor
  def visit_biconditional(formula)
    Biconditional.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_implication(formula)
    Implication.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_negation(formula)
    Negation.new(formula.formula.accept(self))
  end

  def visit_universal(formula)
    Universal.new(formula.variables, formula.formula.accept(self))
  end

  def visit_existential(formula)
    Existential.new(formula.variables, formula.formula.accept(self))
  end

  def visit_disjunction(formula)
    Disjunction.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_conjunction(formula)
    Conjunction.new(formula.left.accept(self), formula.right.accept(self))
  end

  def visit_equality(equality)
    Equality.new(equality.lhs.accept(self), equality.rhs.accept(self))
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