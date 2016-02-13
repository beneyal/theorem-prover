require 'set'
require 'forwardable'
Dir[File.join(File.dirname(__FILE__), '../../**', '*.rb')].each do |f|
  require f
end

class KnowledgeBase
  extend Forwardable

  def_delegators :@kb, :empty?, :size, :clear, :each

  def initialize
    @kb          = []
    @resolver    = Resolution::Resolver.new(self)
    @parser      = FOLParser.new
    @transformer = FOLTransform.new
    @converter   = CNFConverter.new
  end

  def add(sentence)
    cnfed = convert_to_cnf(sentence)
    kb.concat(break_into_clauses(cnfed)).uniq!
  end

  def resolve(i1, j1, i2, j2)
    kb << resolver.resolve(kb[i1], j1, kb[i2], j2)
  end

  def contains_contradiction?
    kb.any? { |clause| clause.empty? }
  end

  def unresolvable?
    kb.each_with_index do |c_i, i|
      kb.each_with_index do |c_j, j|
        return false if i != j && c_i.resolves_with?(c_j)
      end
    end
    true
  end

  def to_s
    kb.each_with_index.map do |clause, i|
      clause.each_with_index.map do |disjunct, j|
        "#{i + 1}-#{j + 1}) #{disjunct}"
      end.join("\n")
    end.join("\n\n")
  end

  private

  attr_reader :parser, :transformer, :converter, :resolver
  attr_accessor :kb, :substitution

  def break_into_clauses(sentence)
    disjunctions = SplitConjunctions.new(sentence).disjunctions
    disjunctions.reduce([]) do |kb, disjunction|
      or_splitter = SplitDisjunctions.new
      disjunction.accept(or_splitter)
      clause = or_splitter.clause.empty? ? Clause.new([disjunction]) : Clause.new(or_splitter.clause)
      kb.each do |other|
        raise ContradictionError, "#{clause} contradicts #{other}." if clause.contradicts?(other)
      end
      kb << clause
    end.reject { |clause| clause.true? }
  end

  def convert_to_cnf(sentence)
    converter.convert(transformer.apply(parser.parse(sentence)))
  end
end