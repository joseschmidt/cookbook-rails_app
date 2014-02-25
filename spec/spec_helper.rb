# encoding: utf-8
require 'chef/sugar'
require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'support/matchers'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end # config.expect_with
end # RSpec

# returns true if platform family matches value (accepts :symbol or 'string')
# rubocop:disable CyclomaticComplexity
def os?(value)
  os = chef_run.node
  case value.to_s
  when 'debian' then os[:platform_family] == 'debian'
  when 'rhel' then os[:platform_family] == 'rhel'
  when 'rhel5' then os[:platform_family] == 'rhel' &&
    os[:platform_version].to_i == 5
  when 'rhel6' then os[:platform_family] == 'rhel' &&
    os[:platform_version].to_i == 6
  else false
  end # case
end # def
# rubocop:enable CyclomaticComplexity
