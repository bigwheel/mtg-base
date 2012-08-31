PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

VCR.configure do |conf|
  conf.cassette_library_dir = 'spec/cassettes'
  conf.hook_into :fakeweb
  conf.configure_rspec_metadata!
end

RSpec.configure do |conf|
  conf.mock_with :rr
  conf.include Rack::Test::Methods
  conf.tty = true
  conf.treat_symbols_as_metadata_keys_with_true_values = true
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  MtgPackGenerator.tap { |app|  }
end

Mongoid.logger.level = Logger::INFO
