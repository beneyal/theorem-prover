require 'rspec'
require_relative '../../../spec_helper'

describe KnowledgeBase do
  context 'contradiction in initial KB' do
    it 'raises an error' do
      expect do
        build(:contradiction_kb).each do |sentence|
          subject.add(sentence)
        end
      end.to raise_error KnowledgeBase::ContradictionError
    end
  end

  it 'does not add tautologies' do
    build(:tautology_kb).each { |sentence| subject.add(sentence) }
    expect(subject).to be_empty
  end

  it 'does not contain duplicate clauses' do
    build(:duplicate_kb).each { |sentence| subject.add(sentence) }
    expect(subject.size).to be == 2
  end
end