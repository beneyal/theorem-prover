require_relative 'substitution'
require_relative 'exceptions'

module Resolution
  class Resolver
    def initialize(kb)
      @kb  = kb
      @sub = Substitution.new
    end

    def resolve(clause_1, i1, clause_2, i2)
      raise Resolution::IncompatiblePredicatesError unless valid_pair?([clause_1[i1], clause_2[i2]])
      unless clause_1.resolves_with?(clause_2, clause_2[i2])
        term_pairs([clause_1[i1], clause_2[i2]]).each do |term_1, term_2|
          new_sub = term_1.unify_with(term_2, sub)
          if new_sub.empty?
            raise Resolution::UnificationError, "#{term_1} does not unify with #{term_2}."
          else
            sub.update(new_sub)
            sub.apply(kb)
          end
        end
      end
      clause_1.resolve_with(clause_2, clause_2[i2])
    end

    private

    attr_reader :sub, :kb

    def term_pairs(predicates)
      pred_1, pred_2 = extract_predicates(predicates)
      pred_1.terms.zip(pred_2.terms)
    end

    def valid_pair?(predicates)
      result         = predicates.length == 2
      result         &&= negated?(predicates)
      pred_1, pred_2 = extract_predicates(predicates)
      result && same_predicate?(pred_1, pred_2)
    end

    def extract_predicates(predicates)
      predicate_1, predicate_2 = predicates
      if predicate_1.is_a?(FirstOrderLogic::Negation)
        [predicate_1.formula, predicate_2]
      else
        [predicate_1, predicate_2.formula]
      end
    end

    def same_predicate?(predicate_1, predicate_2)
      (predicate_1.name == predicate_2.name) &&
          (predicate_1.terms.length == predicate_2.terms.length)
    end

    def negated?(predicates)
      predicates[0].is_a?(FirstOrderLogic::Negation) ^ predicates[1].is_a?(FirstOrderLogic::Negation)
    end
  end
end