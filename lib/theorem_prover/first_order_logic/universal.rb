require_relative 'quantifier'

class Universal < Quantifier
  def accept(visitor)
    visitor.visit_universal self
  end

  protected

  def symbol
    "\u2200"
  end
end