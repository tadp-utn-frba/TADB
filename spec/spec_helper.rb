require 'bundler/setup'
require 'rspec'
require 'rspec/collection_matchers'

require_relative '../lib/tadb'

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
