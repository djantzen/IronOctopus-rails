require 'lib/active_record_fkey_hack'

ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'].to_sym)

fixtures = Dir.glob('test/fixtures/*.{csv,yml}').map { |f| f.sub(/test\/fixtures\//, '').sub(/\.yml/, '') }

ActiveRecord::Fixtures.create_fixtures('test/fixtures', fixtures)
