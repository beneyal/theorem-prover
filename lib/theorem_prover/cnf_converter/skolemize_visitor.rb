require_relative 'cnf_converter'
require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../first_order_logic', '*.rb')].each do |f|
  require f
end

class CNFConverter
  class SkolemizeVisitor < BaseVisitor
    def initialize
      @universal_env   = []
      @existential_env = []
      @skolem_function = ("\u03b1".."\u03ff").collect
      @skolem_constant = ("\u26a0"..."\u26c0").collect
    end

    def visit_universal(formula)
      extend_universal_env(formula.variables)
      result         = super(formula)
      @universal_env -= formula.variables
      result
    end

    def visit_existential(formula)
      extend_existential_env(formula.variables)
      result           = formula.formula.accept(self)
      @existential_env -= formula.variables
      result
    end

    def visit_predicate(predicate)
      Predicate.new(predicate.name, predicate.terms.map { |term| term.accept(self) })
    end

    def visit_function(function)
      Function.new(function.name, function.terms.map { |term| term.accept(self) })
    end

    def visit_variable(variable)
      @existential_env.empty? ? variable : skolemized
    end

    private

    def extend_universal_env(variables)
      @universal_env += variables
    end

    def extend_existential_env(variables)
      @existential_env += variables
    end

    def skolemized
      if @universal_env.empty?
        Constant.new(skolem_constant)
      else
        Function.new(skolem_function, @universal_env.dup)
      end
    end

    def skolem_function
      @skolem_function.next
    end

    def skolem_constant
      @skolem_constant.next
    end
  end
end