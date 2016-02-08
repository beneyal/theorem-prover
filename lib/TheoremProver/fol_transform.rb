require 'parslet'
require 'awesome_print'
Dir[File.join(File.dirname(__FILE__), 'constructs', '*.rb')].each { |f| require f }

class FOLTransform < Parslet::Transform
  rule(variable: simple(:v)) { Variable.new(String(v)) }
  rule(constant: simple(:c)) { Constant.new(String(c)) }
  rule(function: { name: simple(:name), terms: sequence(:terms) }) do
    Function.new(String(name), terms)
  end
  rule(predicate: { name: simple(:name), terms: sequence(:terms) }) do
    Predicate.new(String(name), terms)
  end
  rule(negation: simple(:formula)) { Negation.new(formula) }
  rule(iff: { left: simple(:left), right: simple(:right) }) do
    Biconditional.new(left, right)
  end
  rule(implies: { left: simple(:left), right: simple(:right) }) do
    Implication.new(left, right)
  end
  rule(or: { left: simple(:left), right: simple(:right) }) do
    Disjunction.new(left, right)
  end
  rule(and: { left: simple(:left), right: simple(:right) }) do
    Conjunction.new(left, right)
  end
  rule(equality: { left: simple(:lhs), right: simple(:rhs) }) do
    Equality.new(lhs, rhs)
  end
  rule(quantified: { quantifier: { exists: simple(:e) }, variables: sequence(:vars), formula: simple(:formula) }) do
    Existential.new(vars, formula)
  end
  rule(quantified: { quantifier: { forall: simple(:a) }, variables: sequence(:vars), formula: simple(:formula) }) do
    Universal.new(vars, formula)
  end
end

puts FOLTransform.new.apply(tree) if __FILE__ == $PROGRAM_NAME
