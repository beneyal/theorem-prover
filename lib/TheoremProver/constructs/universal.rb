require_relative 'quantifier'

class Universal < Quantifier
  def accept(visitor)
    visitor.visit_universal self
  end

  def to_s
    "for all #{variables.join(',')}. (#{formula})"
  end
end