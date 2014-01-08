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

  it 'includes recipe mysql::ruby' do
    expect(chef_run).to include_recipe('mysql::ruby')
  end # it

  it 'includes recipe chef-sugar' do
    expect(chef_run).to include_recipe('chef-sugar')
  end # it

  %w(localhost %).each do |domain|
    it "creates user mysqladmin@#{domain}" do
      pending "creates user mysqladmin@#{domain}"
    end # it
  end # .each

  %w(matrix_production matrix_staging).each do |database|
    it "creates database #{database}" do
      pending "creates database #{database}"
    end # it
  end # .each

  it 'grants privileges to user matrix' do
    pending 'grants privileges to user matrix'
  end # it

  it 'grants privileges to user matrix_staging' do
    pending 'grants privileges to user matrix_staging'
  end # it

  it 'grants privileges to user wwuser' do
    pending 'grants privileges to user wwuser'
  end # it

  it 'drops database test' do
    pending 'drops database test'
  end # it

end # describe
