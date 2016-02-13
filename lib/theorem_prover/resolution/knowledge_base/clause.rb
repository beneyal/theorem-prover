require_relative 'knowledge_base'
Dir[File.join(File.dirname(__FILE__), '../../first_order_logic', '*.rb')]
require 'forwardable'

class KnowledgeBase
  class Clause
    include Enumerable
    extend Forwardable

    def_delegators :@clause, :[], :empty?, :each, :length, :join

    def initialize(clause)
      @clause = clause
    end

    def resolve_with(other_clause, other_predicate)
      Clause.new((clause + other_clause.clause).reject do |predicate|
        predicate == other_predicate || complements?(predicate, other_predicate)
      end)
    end

    def apply_substitution(sub)
      clause.map! { |term| term.accept(sub) }
    end

    def contradicts?(other)
      resolves_with?(other) && length == other.length && length == 1
    end

    def resolves_with?(other_clause, other_predicate = nil)
      if other_predicate.nil?
        each do |p_i|
          other_clause.each do |p_j|
            return true if complements?(p_i, p_j)
          end
        end
        false
      else
        any? { |predicate| complements?(predicate, other_predicate) }
      end
    end

    def complements?(predicate_i, predicate_j)
      predicate_i == FirstOrderLogic::Negation.new(predicate_j) ||
          predicate_j == FirstOrderLogic::Negation.new(predicate_i)
    end

    def true?
      each_with_index do |p_i, i|
        each_with_index do |p_j, j|
          return true if i != j && p_i == FirstOrderLogic::Negation.new(p_j)
        end
      end
      false
    end

    def to_s
      join(" \u2228 ".encode('utf-8'))
    end

    def ==(o)
      o.class == self.class && o.clause == clause
    end

    alias_method :eql?, :==

    def hash
      @clause.hash
    end

    protected

    attr_accessor :clause
  end
end