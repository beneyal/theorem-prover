require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each do |f|
  require f
end

class DistributeConjunctionsVisitor < BaseVisitor
  def visit_disjunction(formula)
    left = formula.left.accept(self)
    right = formula.right.accept(self)
    if formula.left.is_a?(Conjunction) && formula.right.is_a?(Conjunction)
      ll = left.left
      lr = left.right
      rl = right.left
      rr = right.right
      Conjunction.new(Disjunction.new(ll, rl),
                      Conjunction.new(Disjunction.new(ll, rr),
                      Conjunction.new(Disjunction.new(lr, rl), Disjunction.new(lr, rr))))
    elsif formula.left.is_a?(Conjunction)
      ll = left.left
      lr = left.right
      Conjunction.new(Disjunction.new(ll, right), Disjunction.new(lr, right))
    elsif formula.right.is_a?(Conjunction)
      rl = right.left
      rr = right.right
      Conjunction.new(Disjunction.new(left, rl), Disjunction.new(left, rr))
    else
      super(formula)
    end
  end
end