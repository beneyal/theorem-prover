require_relative '../constructs/negation'
require_relative 'knowledge_base/clause'
Dir[File.join(File.dirname(__FILE__), '/knowledge_base', '*.rb')].each do |f|
  require f
end

class KnowledgeBase
  def initialize
    @kb = []
  end

  def add(sentence)
    break_into_clauses = break_into_clauses(sentence)
    @kb += break_into_clauses
  end

  def clear
    @kb.clear
  end

  def resolve(first, second)

  end

  def contains_contradiction?
    @kb.any? { |clause| clause.empty? }
  end

  def unresolvable?
    @kb.each do |clause|
      puts clause
      puts "True? #{clause.true?}"
    end
  end

  def to_s
    @kb.each_with_index.map do |clause, i|
      clause.each_with_index.map do |disjunct, j|
        "#{i + 1}-#{j + 1}) #{disjunct}"
      end.join("\n")
    end.join("\n\n")
  end

  private

  def break_into_clauses(sentence)
    disjunctions = SplitConjunctions.new(sentence).disjunctions
    disjunctions.reduce([]) do |kb, disjunction|
      or_splitter = SplitDisjunctions.new
      disjunction.accept(or_splitter)
      if or_splitter.clause.empty?
        kb << Clause.new([disjunction])
      else
        kb << Clause.new(or_splitter.clause)
      end
    end
  end
end