require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each do |f|
  require f
end

class NegationVisitor < BaseVisitor
  def visit_biconditional(_formula)
    raise 'This should never happen'
  end

  def visit_implication(_formula)
    raise 'This should never happen'
  end

  def visit_negation(formula)
    @negated = !negated?
    formula.formula.accept(self)
  end

  def visit_universal(formula)
    if negated?
      @negated = false
      Existential.new(formula.variables,
                      Negation.new(formula.formula.accept(self)))
    else
      super(formula)
    end
  end

  def visit_existential(formula)
    if negated?
      @negated = false
      Universal.new(formula.variables,
                    Negation.new(formula.formula.accept(self)))
    else
      super(formula)
    end
  end

  def visit_disjunction(formula)
    if negated?
      @negated = false
      Conjunction.new(Negation.new(formula.left.accept(self)),
                      Negation.new(formula.right.accept(self)))
    else
      super(formula)
    end
  end

  def visit_conjunction(formula)
    if negated?
      @negated = false
      Disjunction.new(Negation.new(formula.left.accept(self)),
                      Negation.new(formula.right.accept(self)))
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
      Negation.new(atom)
    else
      atom
    end
  end
end