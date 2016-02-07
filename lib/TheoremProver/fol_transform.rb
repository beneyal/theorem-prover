require 'parslet'
require 'awesome_print'
Dir['./TheoremProver/constructs/*.rb'].each { |f| require f }

# for all x, y, z. (there exists a, b, c. (not F(x) and A = f(B) or G(x) -> H(y) and not A(x) <=> B(x)))
tree = {
    quantified: {
        quantifier: {
            forall: 'for all '
        },
        variables:  [
                        {
                            variable: 'x'
                        },
                        {
                            variable: 'y'
                        },
                        {
                            variable: 'z'
                        }
                    ],
        formula:    {
            quantified: {
                quantifier: {
                    exists: 'there exists '
                },
                variables:  [
                                {
                                    variable: 'a'
                                },
                                {
                                    variable: 'b'
                                },
                                {
                                    variable: 'c'
                                }
                            ],
                formula:    {
                    iff: {
                        left:  {
                            implies: {
                                left:  {
                                    or: {
                                        left:  {
                                            and: {
                                                left:  {
                                                    negation: {
                                                        predicate: {
                                                            name:  'F',
                                                            terms: [
                                                                       {
                                                                           variable: 'x'
                                                                       }
                                                                   ]
                                                        }
                                                    }
                                                },
                                                right: {
                                                    equality: {
                                                        left:  {
                                                            constant: 'A'
                                                        },
                                                        right: {
                                                            function: {
                                                                name:  'f',
                                                                terms: [
                                                                           {
                                                                               constant: 'B'
                                                                           }
                                                                       ]
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        },
                                        right: {
                                            predicate: {
                                                name:  'G',
                                                terms: [
                                                           {
                                                               variable: 'x'
                                                           }
                                                       ]
                                            }
                                        }
                                    }
                                },
                                right: {
                                    and: {
                                        left:  {
                                            predicate: {
                                                name:  'H',
                                                terms: [
                                                           {
                                                               variable: 'y'
                                                           }
                                                       ]
                                            }
                                        },
                                        right: {
                                            negation: {
                                                predicate: {
                                                    name:  'A',
                                                    terms: [
                                                               {
                                                                   variable: 'x'
                                                               }
                                                           ]
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        right: {
                            predicate: {
                                name:  'B',
                                terms: [
                                           {
                                               variable: 'x'
                                           }
                                       ]
                            }
                        }
                    }
                }
            }
        }
    }
}

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
