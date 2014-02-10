# coding: utf-8
source 'https://rubygems.org'

group :development do
  gem 'emeril', '~> 0.7.0'
  gem 'pimpmychangelog', '~> 0.1.2'
end # group

group :test do
  gem 'berkshelf', '~> 2.0.10'
  gem 'chef', :github => 'opscode/chef',
              :ref => '8682fe74c6bb8bc549c198cd5ba09f24bf88bfbe'
  gem 'chef-sugar', '~> 1.1.0'
  gem 'chefspec', '~> 3.2.0'
  gem 'foodcritic', '~> 3.0.3'
  gem 'rubocop', '~> 0.18.1'
end # group

group :integration do
  gem 'test-kitchen', '~> 1.1.1'
  gem 'kitchen-vagrant', '~> 0.14.0'
end # group
