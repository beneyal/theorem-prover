require 'rspec'
require_relative '../../spec_helper'

describe Resolution::Substitution do
  let (:kb) { KnowledgeBase.new }
  it 'changes variables in formulas' do
    build(:col_west_kb).each { |sentence| kb.add(sentence) }
    subject.update(FirstOrderLogic::Variable.new('x1') => FirstOrderLogic::Constant.new('West'))
    subject.apply(kb)
    expect(kb.to_s).to_not include 'x1'
  end
end