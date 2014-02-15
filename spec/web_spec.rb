# coding: utf-8
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
      node.set['file']['header'] = 'node.file.header'
      node.set['rails_app']['name'] = 'whiz_bang_app'
      node.set['rails_app']['stages'] = [
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

      # required for build-essential cookbook on travis-ci
      node.set['platform_family'] = 'rhel'
    end.converge(described_recipe)
  end # let

  let(:node) { chef_run.node }

  it 'creates directory /var/www/html' do
    dir = '/var/www/html'
    expect(chef_run).to create_directory(dir)
      .with(:owner => 'root', :group => 'root')
  end # it

  it 'creates user jeeves' do
    expect(chef_run).to create_user('jeeves')
  end # it

  it 'creates multiple symlinks' do
    node['rails_app']['stages'].each do |item|
      link = "/var/www/html/#{item['codename']}"
      expect(chef_run).to create_link(link)
        .with(:owner => 'root', :group => 'root')
    end # .each
  end # it

  it 'includes recipe logrotate_::var_www_apps' do
    expect(chef_run).to include_recipe('logrotate')
  end # it

  describe '/home/jeeves/.ssh' do
    it 'creates directory' do
      expect(chef_run).to create_directory(subject)
        .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0700')
    end # it
  end # describe

  describe '/home/jeeves/.ssh/config' do
    it 'creates template' do
      expect(chef_run).to create_template(subject)
        .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0644')
    end # it

    it 'contains expected content' do
      expect(chef_run).to render_file(subject)
        .with_content('node.file.header')
    end # it
  end # describe

end # describe
