require_relative 'cnf_converter'
require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../first_order_logic', '*.rb')].each do |f|
  require f
end

class CNFConverter
  class SkolemizeVisitor < BaseVisitor
    def initialize
      @scope           = Hash.new { |hash, key| hash[key] = [] }
      @env             = {}
      @skolem_function = ("\u03b1".."\u03ff").collect
      @skolem_constant = ("\u26a1".."\u26bf").collect
    end

    def visit_universal(formula)
      scope[:universal] += formula.variables
      result            = super(formula)
      scope[:universal] -= formula.variables
      result
    end

    def visit_existential(formula)
      scope[:existential] += formula.variables
      result              = formula.formula.accept(self)
      scope[:existential] -= formula.variables
      result
    end

    def visit_predicate(predicate)
      FirstOrderLogic::Predicate.new(predicate.name,
                                     predicate.terms.map { |term| term.accept(self) })
    end

    def visit_function(function)
      FirstOrderLogic::Function.new(function.name,
                                    function.terms.map { |term| term.accept(self) })
    end

    def visit_variable(variable)
      if scope[:existential].empty?
        variable
      elsif env.has_key?(variable)
        env[variable]
      else
        env[variable] = skolemized
      end
    end

    private

    attr_accessor :scope, :env

    def skolemized
      if scope[:universal].empty?
        FirstOrderLogic::Constant.new(skolem_constant)
      else
        FirstOrderLogic::Function.new(skolem_function, scope[:universal].dup)
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