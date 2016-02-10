require_relative 'implication_elimination_visitor'
require_relative 'negation_visitor'
require_relative 'standardize_apart_visitor'
require_relative 'skolemize_visitor'
require_relative 'drop_universals_visitor'

class CNFConverter

  def initialize(root)
    @root = root
    @env = {}
  end

  def convert
    @root = @root.accept ImplicationEliminationVisitor.new
    @root = @root.accept NegationVisitor.new
    @root = @root.accept StandardizeApartVisitor.new
    @root = @root.accept SkolemizeVisitor.new
    @root = @root.accept DropUniversalsVisitor.new
  end
end