class Constant
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
end