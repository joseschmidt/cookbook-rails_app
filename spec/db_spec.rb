require 'spec_helper'

describe 'rails_app::db' do
  before do
    Chef::Sugar::DataBag.stub(:encrypted_data_bag_item).and_return(
      'matrix' => 'matrix_password',
      'matrix_staging' => 'matrix_staging_password',
      'mysql' => {
        'root' => 'root_password'
      },
      'mysqladmin' => 'mysqladmin_password',
      'wwuser' => 'wwuser_password'
    )
  end # before

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      # create a new environment
      env = Chef::Environment.new
      env.name 'qa'

      # stub the node to return this environment
      node.stub(:chef_environment).and_return(env.name)

      # stub any calls to Environment.load to return this environment
      Chef::Environment.stub(:load).and_return(env)

      # override cookbook attributes
      # node.set['key'] = some_value

      # required for build-essential cookbook on travis-ci
      node.set['platform_family'] = 'rhel'
    end.converge(described_recipe)
  end # let

  it 'should include recipe mysql::ruby' do
    chef_run.should include_recipe 'mysql::ruby'
  end # it 'should include recipe mysql::ruby'

  it 'should include recipe chef-sugar' do
    expect(chef_run).to include_recipe('chef-sugar')
  end # it

  %w(localhost %).each do |domain|
    it "should create user mysqladmin@#{domain}" do
      pending "should create user mysqladmin@#{domain}"
    end # it "should create user mysqladmin@#{domain}"
  end # %w(localhost %).each
  
  %w(matrix_production matrix_staging).each do |database|
    it "should create database #{database}" do
      pending "should create database #{database}"
    end # it "should create database #{database}"
  end # %w(matrix_production matrix_staging).each
  
  it 'should grant privileges to user matrix' do
    pending 'should grant privileges to user matrix'
  end # it 'should grant privileges to user matrix'
  
  it 'should grant privileges to user matrix_staging' do
    pending 'should grant privileges to user matrix_staging'
  end # it 'should grant privileges to user matrix_staging'
  
  it 'should grant privileges to user wwuser' do
    pending 'should grant privileges to user wwuser'
  end # it 'should grant privileges to user wwuser'
  
  it 'should drop database test' do
    pending 'should drop database test'
  end # it 'should drop database test'
  
end # describe 'rails_app::db'
