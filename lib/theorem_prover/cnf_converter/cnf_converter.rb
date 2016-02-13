require_relative 'implication_elimination_visitor'
require_relative 'negation_visitor'
require_relative 'standardize_apart_visitor'
require_relative 'skolemize_visitor'
require_relative 'drop_universals_visitor'
require_relative 'distribute_conjunctions_visitor'

class CNFConverter
  def initialize
    @i = ImplicationEliminationVisitor.new
    @n = NegationVisitor.new
    @s = StandardizeApartVisitor.new
    @e = SkolemizeVisitor.new
    @a = DropUniversalsVisitor.new
    @d = DistributeConjunctionsVisitor.new
  end

  def convert(sentence)
    [i, n, s, e, a, d].reduce(sentence) do |exp, visitor|
      exp.accept(visitor)
    end
  end

  private

  attr_reader :i, :n, :s, :e, :a, :d
end