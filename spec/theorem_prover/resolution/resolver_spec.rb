require 'rspec'
require_relative '../../spec_helper'

describe Resolution::Resolver do
  let (:kb) { KnowledgeBase.new }
  it 'should resolve two matching predicates' do
    build(:col_west_kb).each { |sentence| kb.add(sentence) }
    puts kb
    puts '=' * 80
    kb.resolve(0, 4, 8, 0)
    puts kb
    puts '=' * 80
    kb.resolve(9, 0, 6, 0)
    puts kb
    puts '=' * 80
    kb.resolve(4, 1, 10, 0)
    puts kb
    puts '=' * 80
    kb.resolve(2, 0, 11, 0)
    puts kb
    puts '=' * 80
    kb.resolve(3, 2, 12, 0)
    puts kb
    puts '=' * 80
    kb.resolve(2, 0, 13, 0)
    puts kb
    puts '=' * 80
    kb.resolve(1, 0, 14, 0)
    puts kb
    puts '=' * 80
    kb.resolve(15, 0, 5, 1)
    puts kb
    puts '=' * 80
    kb.resolve(7, 0, 16, 0)
    puts kb
    puts '=' * 80
    expect(kb.contains_contradiction?).to be true
  end
end