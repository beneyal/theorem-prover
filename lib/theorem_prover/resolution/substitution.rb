require_relative 'knowledge_base/clause'
require_relative 'substitution_application_visitor'
require 'forwardable'

module Resolution
  class Substitution
    extend Forwardable

    def_delegators :@sub, :[], :fetch, :merge, :update, :to_h

    def initialize
      @sub = {}
    end

    def apply(kb)
      kb.each do |clause|
        clause.apply_substitution(SubstitutionApplicationVisitor.new(self))
      end
    end

    private

    attr_reader :sub
  end
end