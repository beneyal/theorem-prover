require_relative 'abstract_construct'

class Constant < AbstractConstruct
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def accept(visitor)
    visitor.visit_constant self
  end

  def to_s
    name
  end

  protected

  def state
    [@name]
  end
end