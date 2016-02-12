require_relative '../../constructs/negation'

class Clause
  include Enumerable

  def initialize(clause)
    @clause = clause
  end

  def true?
    @clause.each_with_index do |c_i, i|
      @clause.each_with_index do |c_j, j|
        return true if i != j && c_i == Negation.new(c_j)
      end
    end
    false
  end

  def each(&block)
    @clause.each(&block)
  end

  def to_s
    if @clause.length > 1
      "(or #{@clause.join(' ')})"
    else
      @clause[0].to_s
    end
  end
end