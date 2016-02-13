require_relative '../base_visitor'
require_relative 'substitution'

module Resolution
  class Substitution
    class SubstitutionApplicationVisitor < BaseVisitor
      attr_reader :sub

      def initialize(sub)
        @sub = sub
      end

      def visit_equality(equality)
        FirstOrderLogic::Equality.new(equality.lhs.accept(self), equality.rhs.accept(self))
      end

      def visit_predicate(predicate)
        FirstOrderLogic::Predicate.new(predicate.name, predicate.terms.map { |term| term.accept(self) })
      end

      def visit_function(function)
        FirstOrderLogic::Function.new(function.name, function.terms.map { |term| term.accept(self) })
      end

      def visit_variable(variable)
        sub.fetch(variable, variable)
      end

      private :sub
    end
  end
end