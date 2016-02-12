require_relative 'abstract_construct'

class BinaryOp < AbstractConstruct
  attr_reader :left, :right
  def initialize(left, right)
    @left = left
    @right = right
  end

  protected

  def state
    [@left, @right]
  end
end