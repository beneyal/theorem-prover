require 'factory_girl'

FactoryGirl.define do
  factory :col_west_kb, class: Array do
    initialize_with do
      new([
              '(forall (x y z) (-> (and (and (and (American x) (Weapon y)) (Sells x y z)) (Hostile z)) (Criminal x)))',
              '(there exists (x) (and (Owns Nono x) (Missile x)))',
              '(forall (x) (-> (and (Missile x) (Owns Nono x)) (Sells West x Nono)))',
              '(forall (x) (-> (Missile x) (Weapon x)))',
              '(forall (x) (-> (Enemy x America) (Hostile x)))',
              '(American West)',
              '(Enemy Nono America)',
              '(not (Criminal West))'
          ])
    end
  end

  factory :contradiction_kb, class: Array do
    initialize_with { new(['(and (F A) (not (F A)))',
                           '(there exists (x) (not (not (F x))))',
                           '(forall (x) (not (H x)))']) }
  end

  factory :tautology_kb, class: Array do
    initialize_with { new(['(or (not (F A)) (F A))']) }
  end

  factory :duplicate_kb, class: Array do
    initialize_with { new(['(and (and (F A) (F B)) (F A))']) }
  end

  factory :random_kb, class: Array do
    initialize_with do
      new([
              '(forall (x y z) (exists (a b c) (-> (not (and (F x) (G y))) (not (H a c)))))',
              '(forall (x y) (and (exists (x z) (-> (not (and (F x) (G y))) (not (H z x)))) (Heart x)))',
              '(for all (x y) (not (not (and (F x) (G x)))))',
              '(there exists (x) (not (not (F x))))',
              '(forall (x) (not (H x)))',
              '(and (and (F A) (F B)) (and (F C) (F D)))',
              '(or (or (or (F A) (F B)) (F C)) (F D))',
              '(and (or (F A) (F B)) (not (F A)))'
          ])
    end
  end
end