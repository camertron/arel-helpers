$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'arel-helpers/version'

Gem::Specification.new do |s|
  s.name     = 'arel-helpers'
  s.version  = ::ArelHelpers::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'https://github.com/camertron/arel-helpers'
  s.license  = 'MIT'
  s.description = s.summary = 'Useful tools to help construct database queries with ActiveRecord and Arel.'

  s.platform = Gem::Platform::RUBY

  s.add_dependency 'activerecord', '>= 3.1.0', '< 8'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'combustion', '~> 1.3'
  s.add_development_dependency 'database_cleaner', '~> 1.8'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'sqlite3', '~> 1.4.0'

  s.require_path = 'lib'
  s.files = Dir['{lib,spec}/**/*', 'Gemfile', 'History.txt', 'README.md', 'Rakefile', 'arel-helpers.gemspec']
  s.files -= Dir['spec/internal/log', 'spec/internal/log/**/*', 'spec/internal/db', 'spec/internal/db/**/*']
end
