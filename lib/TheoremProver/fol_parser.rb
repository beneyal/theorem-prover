require 'parslet'
require 'parslet/convenience'
require 'awesome_print'

class FOLParser < Parslet::Parser
  rule(:space?) { match('[\s]').repeat(1).maybe }

  rule(:function) { (match('[a-z]') >> match('[[:alnum:]]').repeat).as(:name) >> bracketed(terms.repeat(1).as(:terms)) }
  rule(:variable) { (match('[a-z]') >> match('[[:alnum:]]').repeat).as(:variable) }
  rule(:variables) { variable >> (spaced(',') >> variable).repeat }
  rule(:constant) { (match('[A-Z0-9]') >> match('[[:alnum:]]').repeat).as(:constant) }
  rule(:term) { function.as(:function) | variable | constant }
  rule(:terms) { term >> (spaced(',') >> term).repeat }

  rule(:predicate) { space? >> (match('[A-Z]') >> match('[[:alnum:]]').repeat).as(:name) >> bracketed(terms.repeat(1).as(:terms)) }
  rule(:equality) { term.as(:left) >> space? >> spaced('=') >> term.as(:right) }
  rule(:negation) { space? >> (str('~') | str('not ')) >> formula }
  rule(:and_op) { spaced('/\\') | spaced('and') }
  rule(:or_op) { spaced('\\/') | spaced('or') }
  rule(:implies_op) { spaced('->') | spaced('implies') }
  rule(:iff_op) { spaced('<=>') | spaced('iff') }
  rule(:universal) { spaced('for all') }
  rule(:existential) { spaced('there exists') | spaced('exists') }
  rule(:quantifier) { universal.as(:forall) | existential.as(:exists) }
  rule(:quantified) { quantifier.as(:quantifier) >> variables.repeat(1).as(:variables) >> str('.') >> space? >> formula.as(:formula) }
  rule(:formula) do
    predicate.as(:predicate) | equality.as(:equality) | negation.as(:negation) | quantified.as(:quantified) | binary_exp
  end

  rule(:binary_exp) { iff_exp }

  rule(:iff_exp) { (implies_exp.as(:left) >> iff_op >> iff_exp.as(:right)).as(:iff) | implies_exp }
  rule(:implies_exp) { (or_exp.as(:left) >> implies_op >> implies_exp.as(:right)).as(:implies) | or_exp }
  rule(:or_exp) { (and_exp.as(:left) >> or_op >> or_exp.as(:right)).as(:or) | and_exp }
  rule(:and_exp) { (primary.as(:left) >> and_op >> and_exp.as(:right)).as(:and) | primary }

  rule(:primary) { bracketed(binary_exp) | formula }

  root(:formula)

  private

  def spaced(string)
    match('[\s]').repeat >> str(string) >> match('[\s]').repeat
  end

  def bracketed(atom)
    spaced('(') >> atom >> spaced(')')
  end
end

if __FILE__ == $0
  parser = FOLParser.new

  def iteration(parser)
    print 'FOL$ '
    exp = gets.chomp
    ap parser.parse_with_debug(exp), :index => false
    true
  end

  while iteration(parser);
  end
end