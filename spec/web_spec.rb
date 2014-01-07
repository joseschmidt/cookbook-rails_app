require 'spec_helper'

describe 'rails_app::web' do
  before do
    Chef::Sugar::DataBag.stub(:encrypted_data_bag_item).and_return(
      'stage1_db_username' => 'stage1_db_password',
      'stage2_db_username' => 'stage2_db_password'
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
      node.set['file'] = {
        'header' => 'node.file.header'
      }
      node.set['rails_app'] = {
        'name' => 'whiz_bang_app',
        'stages' => [
          {
            'name'                    => 'stage1',
            'codename'                => 'st1',
            'db_username'             => 'stage1_db_user'
          },
          {
            'name'                    => 'stage2',
            'codename'                => 'st2',
            'db_username'             => 'stage2_db_user'
          }
        ]
      }

      # required for build-essential cookbook on travis-ci
      node.set['platform_family'] = 'rhel'
    end.converge(described_recipe)
  end # let

  let(:node) { chef_run.node }

  it 'should create directory /var/www/html' do
    dir = '/var/www/html'
    expect(chef_run).to create_directory(dir)
      .with(:owner => 'root', :group => 'root')
  end # it 'should create directory /var/www/html'
  
  it 'should create user jeeves' do
    chef_run.should create_user 'jeeves'
  end # it 'should create user jeeves'

  it 'should create multiple symlinks' do
    node['rails_app']['stages'].each do |item|
     link = "/var/www/html/#{item['codename']}"
      expect(chef_run).to create_link(link)
        .with(:owner => 'root', :group => 'root')
    end # node['rails_app']['stages'].each
  end # it 'should create multiple symlinks'
  
  it 'should include recipe logrotate_::var_www_apps' do
    chef_run.should include_recipe 'logrotate'
  end # it 'should include recipe logrotate_::var_www_apps'
  
end # describe 'rails_app::web'
