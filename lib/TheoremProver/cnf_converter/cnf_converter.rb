require_relative 'implication_elimination_visitor'
require_relative 'negation_visitor'

class CNFConverter

  def initialize(root)
    @root = root
    @env = {}
  end

  def convert
    @root = @root.accept ImplicationEliminationVisitor.new
    @root = @root.accept NegationVisitor.new
  end
end