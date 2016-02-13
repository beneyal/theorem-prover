require 'set'
require 'forwardable'
Dir[File.join(File.dirname(__FILE__), '../**', '*.rb')].each do |f|
  require f
end

class KnowledgeBase
  extend Forwardable

  def_delegators :@kb, :empty?, :size, :clear

  def initialize
    @kb           = []
    @substitution = Substitution.new
    @parser       = FOLParser.new
    @transformer  = FOLTransform.new
  end

  def add(sentence)
    cnfed = convert_to_cnf(sentence)
    kb.concat(break_into_clauses(cnfed)).uniq!
  end

  def resolve(i1, j1, i2, j2)
    raise IncompatibleTermsError unless negated?(kb[i1][j1], kb[i2][j2])
    predicate_i, predicate_j = extract_predicates(kb[i1][j1], kb[i2][j2])
    raise IncompatibleTermsError unless same_predicate?(predicate_i, predicate_j)
  end

  def extract_predicates(predicate_i, predicate_j)
    if predicate_i.is_a?(Negation)
      [predicate_i.formula, predicate_j]
    else
      [predicate_i, predicate_j.formula]
    end
  end

  def same_predicate?(predicate_i, predicate_j)
    (predicate_i.name == predicate_j.name) && (predicate_i.terms.length == predicate_j.terms.length)
  end

  def negated?(predicate_i, predicate_j)
    predicate_i.is_a?(Negation) ^ predicate_j.is_a?(Negation)
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

  attr_reader :parser, :transformer
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
    CNFConverter.convert(transformer.apply(parser.parse(sentence)))
  end
end