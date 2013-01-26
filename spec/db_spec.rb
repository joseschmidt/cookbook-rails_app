require 'chefspec'
require 'fauxhai'
require 'librarian/chef/integration/knife'

describe 'rails_app::db' do
  before do
    Fauxhai.mock(:environment => 'qa')
    Chef::EncryptedDataBagItem.stub(:load).and_return({
      'matrix' => 'matrix_password',
      'matrix_staging' => 'matrix_staging_password',
      'mysql' => {
        'root' => 'root_password'
      },
      'mysqladmin' => 'mysqladmin_password',
      'wwuser' => 'wwuser_password'
    })
  end # before
  
  opts = { :cookbook_path => Librarian::Chef.install_path.to_s }
  let (:chef_run) { ChefSpec::ChefRunner.new(opts).converge 'rails_app::db' }
  
  it 'should include recipe mysql::ruby' do
    chef_run.should include_recipe 'mysql::ruby'
  end # it 'should include recipe mysql::ruby'
  
  it 'should include recipe helpers' do
    chef_run.should include_recipe 'helpers'
  end # it 'should include recipe helpers'
  
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
