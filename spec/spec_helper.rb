require_relative '../config/application'

require_relative '../lib/fixtures/fixtures.rb'

require 'factory_bot'
require_relative 'factories/factory'

require 'machinist'
require_relative 'blueprints'


RSpec.configure do |config|
  # == Mock Framework
  # config.mock_with :mocha

  config.include FactoryBot::Syntax::Methods rescue nil
end
