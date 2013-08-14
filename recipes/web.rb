#
# Cookbook Name:: rails_app
# Recipe:: web
#
# Author:: Doc Walker (<doc.walker@jameshardie.com>)
#
# Copyright 2012-2013, James Hardie Building Products, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'helpers'

# retrieve contents of encrypted data bag (refer to chef-repo/ENCRYPTED.md)
secret = decrypt_data_bag(:encrypted)

#-------------------------------------------------------- install dependencies
node['rails_app']['packages'].each do |pkg|
  package pkg
end # node['rails_app']['packages'].each

# nodejs requires python 2.6; the symlink below allows #!/usr/bin/env python
# to use v2.6, provided /usr/local/bin comes before /usr/bin in $PATH
# action :create allows it to repair missing link
link '/usr/local/bin/python' do
  to    '/usr/bin/python26'
  owner 'root'
  group 'root'
  action :create
  subscribes :create, resources('package[python26]'), :immediately
end # link

#------------------ create user, directories, symlinks, database configuration
# user must exist in order to adjust owner/group settings below
user 'jeeves'

# create base directory for public html access
directory '/var/www/html' do
  owner     'root'
  group     'root'
  mode      '0755'
  recursive true
end # directory

node['rails_app']['stages'].each do |stage|
  
  # ln -s ../apps/<app>/<stage>/current/public /var/www/html/<codename>
  link "/var/www/html/#{stage['codename']}" do
    to    "../apps/#{node['rails_app']['name']}/#{stage['name']}/current/public"
    owner 'root'
    group 'root'
  end # link
  
  base = "/var/www/apps/#{node['rails_app']['name']}/#{stage['name']}"
  # create /var/www/apps/<app>/<stage>/shared/config directory
  directory "#{base}/shared/config" do
    owner     'jeeves'
    group     'jeeves'
    mode      '0755'
    recursive true
  end # directory
  
  # ln -s /tmp /var/www/apps/<app>/<stage>/current
  link "#{base}/current" do
    to    '/tmp'
    owner 'jeeves'
    group 'jeeves'
    not_if { ::File.symlink?("#{base}/current") }
  end # link
  
  file "#{base}/current/REVISION" do
    owner   'jeeves'
    group   'jeeves'
    mode    '0755'
    action  :create_if_missing
  end # file
  
  # create rails database configuration file
  template 'database.yml' do |t|
    path      "#{base}/shared/config/database.yml"
    owner     'jeeves'
    group     'jeeves'
    mode      '0600'
    variables(
      :stage        => stage['name'],
      :db_port      => stage['db_port'],
      :db_database  => stage['db_database'],
      :db_username  => stage['db_username'],
      :db_password  => secret[stage['db_username']]
    )
  end # template
  
end # node['rails_app']['stages'].each

# adjust permissions on /var/www/html/<app>
execute "chown -R jeeves:jeeves /var/www/apps/#{node['rails_app']['name']}"

#------------------------------------------------------- configure logrotate.d
include_recipe 'logrotate'

# create configuration file in /etc/logrotate.d/
logrotate_app 'var_www_apps' do
  cookbook    'logrotate'
  path        '/var/www/apps/**/**/shared/log/*.log'
  frequency   'daily'
  options     %w(missingok compress delaycompress sharedscripts)
  rotate      30
  postrotate  'touch /var/www/apps/**/**/current/tmp/restart.txt'
end # logrotate_app

#----------------------------------------------------- configure github access
template '/home/jeeves/.ssh/config' do |t|
  owner   'jeeves'
  group   'jeeves'
  mode    '0644'
  variables(
    :header => node['file']['header'].gsub('@filename', t.name).
      gsub('@hostname', node['hostname'])
  )
end # template

template '/home/jeeves/.ssh/matrix_deploy_key' do |t|
  source  'ssh_key.erb'
  owner   'jeeves'
  group   'jeeves'
  mode    '0600'
  variables(
    :header => node['file']['header'].gsub('@filename', t.name).
      gsub('@hostname', node['hostname']),
    :private_key => secret['matrix_deploy_key']
  )
end # template

file '/home/jeeves/.ssh/remote_deploy_key' do |f|
  action :delete
end # file

file '/etc/cron.hourly/remote-deploy' do |f|
  action :delete
end # file
