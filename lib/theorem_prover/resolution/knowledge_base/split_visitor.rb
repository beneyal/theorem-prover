require_relative '../../base_visitor'

class KnowledgeBase
  class SplitVisitor < BaseVisitor
    def break_exp(formula, container)
      left  = formula.left.accept(self)
      right = formula.right.accept(self)
      container << left unless left.nil?
      container << right unless right.nil?
      nil
    end
  end
end