require 'theorem_prover/version'
require_relative 'theorem_prover/parser/fol_parser'
require_relative 'theorem_prover/parser/fol_transform'
require_relative 'theorem_prover/cnf_converter/cnf_converter'
require_relative 'theorem_prover/resolution/knowledge_base'

module TheoremProver
  class REPL
    STEP_ONE   = 'Build Initial Knowledge Base'
    STEP_TWO   = 'Proposition to Prove'
    STEP_THREE = 'Resolution'
    STEP_FOUR  = 'Result'
    PROMPT     = '~> '
    STOP       = 'fuck'

    attr_reader :kb

    def initialize
      @kb = KnowledgeBase.new
    end

    def run
      print_build_initial_kb
      build_initial_kb
      print_proposition_to_prove
      proposition_to_prove
      print_resolution
      resolution
    end

    def print_resolution
      print_title(STEP_THREE)
    end

    def resolution
      until kb.contains_contradiction? || kb.unresolvable?
        puts kb
        puts 'Your present KB is shown above. Please enter the two terms you wish to resolve:'
        print 'First: '
        first = get_input_for_resolution
        print 'Second: '
        second = get_input_for_resolution
        kb.resolve(first, second)
      end
    end

    def proposition_to_prove
      print PROMPT
      kb.add(convert_to_cnf(gets.chomp))
    end

    def print_proposition_to_prove
      print_title(STEP_TWO)
      puts 'Please enter the proposition you would like to prove in LISP-y First-Order Logic.'
    end

    def convert_to_cnf(sentence)
      CNFConverter.new(FOLTransform.new.apply(FOLParser.new.parse(sentence))).convert
    end

    def print_title(title)
      puts title
      puts '=' * title.length
      puts
    end

    def build_initial_kb
      print PROMPT
      until (sentence = gets.chomp) == STOP
        kb.add(convert_to_cnf(sentence))
        print PROMPT
      end
    end

    def print_build_initial_kb
      print_title(STEP_ONE)
      puts "Please enter sentences in LISP-y First-Order Logic. Enter `#{STOP}` when done."
    end

    def get_input_for_resolution
      i, j = gets.chomp.split('_')
      [i, j].map { |n| n.to_i - 1 }
    end

    def test_run
      puts 'Please enter a sentence in First-Order Logic'
      # sentence = gets.chomp
      sentences = ['(forall (x y z) (exists (a b c) (-> (not (and (F x) (G y))) (not (H a c)))))',
                   '(forall (x y) (and (exists (x z) (-> (not (and (F x) (G y))) (not (H z x)))) (Heart x)))',
                   '(for all (x y) (not (not (and (F x) (G x)))))',
                   '(there exists (x) (not (not (F x))))',
                   '(forall (x) (not (H x)))',
                   '(and (and (F A) (F B)) (and (F C) (F D)))',
                   '(or (or (or (F A) (F B)) (F C)) (F D))',
                   '(and (F A) (not (F A)))',
                   '(or (not (F A)) (F A))']
      sentences.each do |sentence|
        cnf = CNFConverter.new(FOLTransform.new.apply(FOLParser.new.parse(sentence))).convert
        kb.add(cnf)
        puts kb
        kb.clear
        puts '-' * 80
      end
    end
  end
  REPL.new.test_run
end
