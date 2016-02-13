require 'factory_girl'
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.find_definitions
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'theorem_prover'
