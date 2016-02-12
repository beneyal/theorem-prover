require_relative 'abstract_construct'

class Variable < AbstractConstruct
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def accept(visitor)
    visitor.visit_variable self
  end

  def to_s
    name
  end

  protected

  def state
    [@name]
  end
end