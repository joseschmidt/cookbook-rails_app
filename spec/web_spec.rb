require 'chefspec'
require 'fauxhai'
require 'librarian/chef/integration/knife'

describe 'rails_app::web' do
  before do
    Fauxhai.mock do |node|
      node['rails_app'] = {
        'name' => 'whiz_bang_app',
        'stages' => {
          'stage1' => 'st1',
          'stage2' => 'st2',
          'stage3' => 'st3'
        }
      }
    end # Fauxhai.mock
  end # before
  
  opts = { :cookbook_path => Librarian::Chef.install_path.to_s }
  let (:runner) { ChefSpec::ChefRunner.new(opts) }
  let (:chef_run) { runner.converge 'rails_app::web' }
  
  it 'should create directory /var/www/html' do
    dir = '/var/www/html'
    chef_run.should create_directory dir
    chef_run.directory(dir).should be_owned_by 'root', 'root'
  end # it 'should create directory /var/www/html'
  
  it 'should create user jeeves' do
    chef_run.should create_user 'jeeves'
  end # it 'should create user jeeves'
  
  it 'should create multiple directories' do
    runner.node['rails_app']['stages'].each do |item|
      dir = "/var/www/apps/#{runner.node.rails_app.name}/#{item['stage']}/current/public"
      chef_run.should create_directory dir
      chef_run.directory(dir).should be_owned_by 'jeeves', 'jeeves'
    end # runner.node['rails_app']['stages'].each
  end # it 'should create multiple directories'
  
  it 'should create multiple symlinks' do
    runner.node['rails_app']['stages'].each do |item|
     link = "/var/www/html/#{item['codename']}"
      chef_run.should create_link link
      chef_run.link(link).should be_owned_by 'root', 'root'
    end # runner.node['rails_app']['stages'].each
  end # it 'should create multiple symlinks'
  
  it 'should include recipe logrotate_d::var_www_apps' do
    chef_run.should include_recipe 'logrotate_d::var_www_apps'
  end # it 'should include recipe logrotate_d::var_www_apps'
  
end # describe 'rails_app::web'
