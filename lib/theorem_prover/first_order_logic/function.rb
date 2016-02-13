require_relative 'term'

module FirstOrderLogic
  class Function < Term
    attr_reader :name, :terms

    def initialize(name, terms)
      @name  = name
      @terms = terms
    end

    def accept(visitor)
      visitor.visit_function self
    end

    def unify_with(other, sub)
      other.unify_with_function(self, sub)
    end

    def unify_with_variable(variable, sub)
      unify_with(variable, sub)
    end

    def unify_with_function(function, sub)
      if self == function
        sub.to_h
      else
        {}
      end
    end

    def to_s
      "#{name}(#{terms.join(', ')})"
    end

    protected

    def state
      [@name, @terms]
    end
  end
end