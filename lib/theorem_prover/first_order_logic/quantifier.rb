require_relative 'formula'

module FirstOrderLogic
  class Quantifier < Formula
    attr_reader :variables, :formula

    def initialize(variables, formula)
      @variables = variables
      @formula   = formula
    end

    def to_s
      "#{symbol} #{variables.join(', ')}. #{formula}"
    end

    protected

    def symbol
      raise NotImplementedError
    end

    def state
      [@variables, @formula]
    end
  end
end