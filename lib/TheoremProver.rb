require "TheoremProver/version"
require_relative 'TheoremProver/fol_parser'
require_relative 'TheoremProver/fol_transform'
require_relative 'TheoremProver/cnf_converter/cnf_converter'

module TheoremProver
  puts 'Please enter a sentence in First-Order Logic'
  # sentence = gets.chomp
  sentences = ['for all x, y, z. (there exists a, b, c. ( (not (F(x) and G(x))) -> (not H(x)) ) )',
               '(not (not (F(x) and G(x))))',
               '(not (not F(x)))',
               'not H(x)']
  sentences.each do |sentence|
    root = FOLTransform.new.apply(FOLParser.new.parse(sentence))
    puts CNFConverter.new(root).convert
  end
end
