# coding: utf-8
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |config|
  config.before :all do
    config.path = '/sbin:/usr/sbin'
  end # config.before

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end # config.expect_with
end # RSpec
