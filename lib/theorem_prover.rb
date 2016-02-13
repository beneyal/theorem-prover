require 'theorem_prover/version'
require_relative 'theorem_prover/resolution/knowledge_base/knowledge_base'

module TheoremProver
  class REPL
    STEP_ONE   = 'Build Initial Knowledge Base'
    STEP_TWO   = 'Proposition to Prove'
    STEP_THREE = 'Resolution'
    STEP_FOUR  = 'Result'
    PROMPT     = '~> '
    STOP       = 'fuck'
    SEPERATOR  = '-'

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
        kb.resolve(*first, *second)
      end
    end

    def proposition_to_prove
      print PROMPT
      kb.add(gets.chomp)
    end

    def print_proposition_to_prove
      print_title(STEP_TWO)
      puts 'Please enter the proposition you would like to prove in LISP-y First-Order Logic.'
    end

    def print_title(title)
      puts title
      puts '=' * title.length
      puts
    end

    def build_initial_kb
      print PROMPT
      until (sentence = gets.chomp) == STOP
        kb.add(sentence)
        print PROMPT
      end
    end

    def print_build_initial_kb
      print_title(STEP_ONE)
      puts "Please enter sentences in LISP-y First-Order Logic. Enter `#{STOP}` when done."
    end

    def get_input_for_resolution
      i, j = gets.chomp.split(SEPERATOR)
      [i, j].map { |n| n.to_i - 1 }
    end
  end
end
