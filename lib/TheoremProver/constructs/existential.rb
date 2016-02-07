require_relative 'quantifier'

class Existential < Quantifier
  def accept(visitor)
    visitor.visit_existential self
  end

  def to_s
    "exists #{variables.join(',')}. (#{formula})"
  end
end