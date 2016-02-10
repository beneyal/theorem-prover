require 'theorem_prover/version'
require_relative 'theorem_prover/fol_parser'
require_relative 'theorem_prover/fol_transform'
require_relative 'theorem_prover/cnf_converter/cnf_converter'

module TheoremProver
  puts 'Please enter a sentence in First-Order Logic'
  # sentence = gets.chomp
  sentences = ['(A (x y z) (E (a b c) (-> (not (and (F x) (G y))) (not (H a c)))))',
               '(A (x y) (and (E (x z) (-> (not (and (F x) (G y))) (not (H z x)))) (Heart x)))',
               '(for all (x y) (not (not (and (F x) (G x)))))',
               '(there exists (x) (not (not (F x))))',
               '(forall (x) (not (H x)))']
  sentences.each do |sentence|
    root = FOLTransform.new.apply(FOLParser.new.parse(sentence))
    puts CNFConverter.new(root).convert
  end
end
