require_relative '../../base_visitor'

class Substitution
  class SubstitutionApplicationVisitor < BaseVisitor
    attr_reader :sub
    def initialize(sub)
      @sub = sub
    end

    def visit_equality(equality)
      Equality.new(equality.lhs.accept(self), equality.rhs.accept(self))
    end

    def visit_predicate(predicate)
      Predicate.new(predicate.name, predicate.terms.map { |term| term.accept(self) })
    end

    def visit_function(function)
      Function.new(function.name, function.terms.map { |term| term.accept(self) })
    end

    def visit_variable(variable)
      sub.fetch(variable, variable)
    end

    private :sub
  end
end