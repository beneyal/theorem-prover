require_relative 'cnf_converter'
require_relative '../base_visitor'
Dir[File.join(File.dirname(__FILE__), '../first_order_logic', '*.rb')].each do |f|
  require f
end

class CNFConverter
  class DropUniversalsVisitor < BaseVisitor
    def visit_universal(formula)
      formula.formula.accept(self)
    end
  end
end