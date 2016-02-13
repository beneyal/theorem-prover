require_relative 'formula'

module FirstOrderLogic
  class Negation < Formula
    attr_reader :formula

    def initialize(formula)
      @formula = formula
    end

    def accept(visitor)
      visitor.visit_negation self
    end

    def to_s
      "\u00ac#{formula}"
    end

    protected

    def state
      [@formula]
    end
  end
end