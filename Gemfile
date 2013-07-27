source 'https://rubygems.org'

ruby '1.9.3'

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'erubis', "~> 2.7.0"
gem 'mongoid'
gem 'bson_ext'

# Test requirements
gem 'rr', :group => "test"
gem 'rspec', :group => "test"
gem 'rack-test', :require => "rack/test", :group => "test"

# Padrino Stable Gem
gem 'padrino', '0.10.7'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.7'
# end

gem 'thin'
gem 'nokogiri'
gem 'fakeweb'
gem 'vcr'
gem 'pry'
gem 'pry-padrino'
gem 'gatherer-scraper', git: 'git://github.com/bigwheel/gatherer-scraper.git'

# Force Tilt 1.3 to avoid resolver bug: https://github.com/carlhuda/bundler/issues/2464
gem 'tilt', '1.3.7'
