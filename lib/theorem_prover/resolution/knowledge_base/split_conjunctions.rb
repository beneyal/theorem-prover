require_relative 'split_visitor'

class KnowledgeBase
  class SplitConjunctions < SplitVisitor
    def initialize(sentence)
      @sentence     = sentence
      @disjunctions = []
    end

    def disjunctions
      @sentence.accept(self)
      if @disjunctions.empty?
        [@sentence.dup]
      else
        @disjunctions.uniq.dup
      end
    end

    def visit_conjunction(formula)
      break_exp(formula, @disjunctions)
    end
  end
end