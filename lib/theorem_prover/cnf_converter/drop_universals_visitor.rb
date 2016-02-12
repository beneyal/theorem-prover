require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../constructs', '*.rb')].each do |f|
  require f
end

class DropUniversalsVisitor < BaseVisitor
  def visit_universal(formula)
    formula.formula.accept(self)
  end
end