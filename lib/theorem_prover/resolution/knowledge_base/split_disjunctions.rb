require_relative 'split_visitor'

class KnowledgeBase
  class SplitDisjunctions < SplitVisitor
    def initialize
      @clause = Set.new
    end

    def clause
      @clause.dup.to_a
    end

    def visit_disjunction(formula)
      break_exp(formula, @clause)
    end
  end
end