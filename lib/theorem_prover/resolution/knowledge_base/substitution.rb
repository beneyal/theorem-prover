require_relative '../knowledge_base'
require_relative 'clause'
require 'forwardable'

class KnowledgeBase
  class Substitution
    extend Forwardable

    def_delegators :@sub, :[], :fetch

    def initialize
      @sub = {}
    end

    def apply(kb)
      kb.each do |clause|
        clause.apply_substitution({ Variable.new('x1') => Constant.new('West') })
      end
    end

    private

    attr_reader :sub
  end
end