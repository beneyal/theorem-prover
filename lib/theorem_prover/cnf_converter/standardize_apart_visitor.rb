require_relative 'base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each do |f|
  require f
end

class StandardizeApartVisitor < BaseVisitor
  def initialize
    @counter = 1
    @env = []
  end

  def visit_universal(formula)
    vars = extend_env(formula.variables)
    result = Universal.new(vars, formula.formula.accept(self))
    @env.shift
    result
  end

  def visit_existential(formula)
    vars = extend_env(formula.variables)
    result = Existential.new(vars, formula.formula.accept(self))
    @env.shift
    result
  end

  def visit_predicate(predicate)
    Predicate.new(predicate.name, predicate.terms.map { |term| term.accept(self) })
  end

  def visit_function(function)
    Function.new(function.name, function.terms.map { |term| term.accept(self) })
  end

  def visit_variable(variable)
    renamed(variable)
  end

  private

  def extend_env(variables)
    renamed = {}
    variables.each do |var|
      renamed[var.name.to_sym] = Variable.new("#{var}#{@counter}")
    end
    @env.unshift(renamed)
    @counter += 1
    renamed.values
  end

  def renamed(variable)
    @env.each do |frame|
      return frame[variable.name.to_sym] if frame.has_key? variable.name.to_sym
    end
    raise "#{variable.name} is not quantified"
  end
end