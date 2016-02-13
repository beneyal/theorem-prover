require_relative 'term'

module FirstOrderLogic
  class Variable < Term
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def accept(visitor)
      visitor.visit_variable self
    end

    def unify_with(other, sub)
      other.unify_with_variable(self, sub)
    end

    def unify_with_variable(variable, sub)
      sub.merge(variable => self)
    end

    def unify_with_function(function, sub)
      if sub[self].nil?
        sub.merge(self => function)
      else
        term = self
        while sub.has_key?(term)
          term = sub[term]
        end
        unify_with(term, sub)
      end
    end

    def to_s
      name
    end

    protected

    def state
      [@name]
    end
  end
end