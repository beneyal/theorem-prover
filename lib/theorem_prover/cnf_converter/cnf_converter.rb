require_relative 'implication_elimination_visitor'
require_relative 'negation_visitor'
require_relative 'standardize_apart_visitor'
require_relative 'skolemize_visitor'
require_relative 'drop_universals_visitor'
require_relative 'distribute_conjunctions_visitor'

class CNFConverter

  def initialize(root)
    @root = root
  end

  def convert
    [ImplicationEliminationVisitor, NegationVisitor, StandardizeApartVisitor,
     SkolemizeVisitor, DropUniversalsVisitor, DistributeConjunctionsVisitor].reduce(@root) do |exp, visitor|
      exp.accept(visitor.new)
    end
  end
end