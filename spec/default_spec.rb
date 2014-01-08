# coding: utf-8
require 'spec_helper'

describe 'rails_app::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge(described_recipe) }
end # describe
