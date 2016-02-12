require 'parslet'
require 'parslet/convenience'
require 'awesome_print'

class FOLParser < Parslet::Parser
  rule(:space) { match('[\s]').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:function) do
    str('(') >> (match('[a-z]') >> match('[[:alnum:]]').repeat).as(:name) >> space >> terms.repeat(1).as(:terms) >> str(')')
  end
  rule(:variable) { (match('[a-z]') >> match('[[:alnum:]]').repeat).as(:variable) }
  rule(:variables) { variable >> (space >> variable).repeat }
  rule(:constant) { (match('[A-Z0-9]') >> match('[[:alnum:]]').repeat).as(:constant) }
  rule(:term) {  function.as(:function) | variable | constant }
  rule(:terms) { term >> (space >> term).repeat }

  rule(:predicate) do
    (match('[A-Z]') >> match('[[:alnum:]]').repeat).as(:name) >> space >> terms.repeat(1).as(:terms)
  end
  rule(:equality) { str('=') >> space >> term.as(:left) >> space >> term.as(:right) }
  rule(:negation) { (str('~') | str('not')) >> space >> formula }
  rule(:land) do
    (str('/\\') | str('and')) >> space >> (formula.as(:left) >> space >> formula.as(:right)).as(:and)
  end
  rule(:lor) do
    (str('\\/') | str('or')) >> space >> (formula.as(:left) >> space >> formula.as(:right)).as(:or)
  end
  rule(:implies) do
    (str('->') | str('implies')) >> space >> (formula.as(:left) >> space >> formula.as(:right)).as(:implies)
  end
  rule(:iff) do
    (str('<=>') | str('iff')) >> space >> (formula.as(:left) >> space >> formula.as(:right)).as(:iff)
  end
  rule(:binary_op) { land | lor | implies | iff }
  rule(:universal) { str('for all') | str('forall') }
  rule(:existential) { str('there exists') | str('exists') }
  rule(:quantifier) { universal.as(:forall) | existential.as(:exists) }
  rule(:quantified) do
    quantifier >> space >> str('(') >> variables.repeat(1).as(:variables) >> str(')') >> space >> formula.as(:formula)
  end
  rule(:formula) do
    str('(') >> (binary_op |
        quantified.as(:quantified) |
        predicate.as(:predicate) |
        negation.as(:negation) |
        equality.as(:equality)) >> str(')')
  end
  root(:formula)
end

if __FILE__ == $PROGRAM_NAME
  parser = FOLParser.new
  exp = '(A (x y) (and (E (x z) (-> (not (and (F x) (G y))) (not (H z x)))) (and (= x (f x)) (Heart x))))'
  ap parser.parse_with_debug(exp), :index => false
end