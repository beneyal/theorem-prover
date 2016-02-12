require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each do |f|
  require f
end

class SkolemizeVisitor < BaseVisitor
  def initialize
    @counter         = 0
    @universal_env   = []
    @existential_env = []
    @skolem_symbol   = ("\u03b1".."\u03ff").collect
  end

  def visit_universal(formula)
    extend_universal_env(formula.variables)
    result = super(formula)
    @universal_env -= formula.variables
    result
  end

  def visit_existential(formula)
    extend_existential_env(formula.variables)
    result = formula.formula.accept(self)
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
    @existential_env.empty? ? variable : skolem_function
  end

  private

  def extend_universal_env(variables)
    @universal_env += variables
  end

  def extend_existential_env(variables)
    @existential_env += variables
  end

  def skolem_function
    @counter += 1
    if @universal_env.empty?
      Constant.new("S#{@counter}")
    else
      Function.new("#{skolem_symbol}", @universal_env.dup)
    end
  end

  def skolem_symbol
    @skolem_symbol.next.encode('utf-8')
  end
end