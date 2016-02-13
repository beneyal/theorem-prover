require_relative 'cnf_converter'
require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../first_order_logic', '*.rb')].each do |f|
  require f
end

class CNFConverter
  class DistributeConjunctionsVisitor < BaseVisitor
    def visit_disjunction(formula)
      left  = formula.left.accept(self)
      right = formula.right.accept(self)
      if formula.left.is_a?(FirstOrderLogic::Conjunction) && formula.right.is_a?(FirstOrderLogic::Conjunction)
        ll = left.left
        lr = left.right
        rl = right.left
        rr = right.right
        FirstOrderLogic::Conjunction.new(FirstOrderLogic::Disjunction.new(ll, rl),
                                         FirstOrderLogic::Conjunction.new(FirstOrderLogic::Disjunction.new(ll, rr),
                                                                          FirstOrderLogic::Conjunction.new(Disjunction.new(lr, rl),
                                                                                                           FirstOrderLogic::Disjunction.new(lr, rr))))
      elsif formula.left.is_a?(FirstOrderLogic::Conjunction)
        ll = left.left
        lr = left.right
        FirstOrderLogic::Conjunction.new(FirstOrderLogic::Disjunction.new(ll, right),
                                         FirstOrderLogic::Disjunction.new(lr, right))
      elsif formula.right.is_a?(FirstOrderLogic::Conjunction)
        rl = right.left
        rr = right.right
        FirstOrderLogic::Conjunction.new(FirstOrderLogic::Disjunction.new(left, rl),
                                         FirstOrderLogic::Disjunction.new(left, rr))
      else
        super(formula)
      end
    end
  end
end