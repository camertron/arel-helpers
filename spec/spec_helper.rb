$LOAD_PATH.push(File.dirname(__FILE__))

require 'rspec'
require 'arel-helpers'
require 'fileutils'

require 'combustion'
Combustion.initialize! :active_record

require 'database_cleaner'
require 'env/models'

RSpec.configure do |config|
  DatabaseCleaner.strategy = :transaction

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }

  config.before { DatabaseCleaner.start }
  config.after  { DatabaseCleaner.clean }
end
