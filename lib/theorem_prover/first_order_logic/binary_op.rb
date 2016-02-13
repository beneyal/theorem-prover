require_relative 'formula'

module FirstOrderLogic
  class BinaryOp < Formula
    attr_reader :left, :right

    def initialize(left, right)
      @left  = left
      @right = right
    end

    def to_s
      "#{left} #{symbol} #{right}"
    end

    protected

    def symbol
      raise NotImplementedError
    end

    def state
      [@left, @right]
    end
  end
end