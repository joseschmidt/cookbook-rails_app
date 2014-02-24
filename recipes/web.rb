# coding: utf-8
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

include_recipe 'chef-sugar'
include_recipe 'yum::epel' if platform_family?('rhel')

# retrieve contents of encrypted data bag (refer to chef-repo/ENCRYPTED.md)
secret = encrypted_data_bag_item(:encrypted, node.chef_environment)

#-------------------------------------------------------- install dependencies
Chef::Config['yum_timeout'] = 1800
# gem ruby-odbc-0.99994 requires unixODBC-devel
package 'unixODBC-devel'

# gem tiny_tds-0.5.1 requires freetds, freetds-devel
%w(freetds freetds-devel).each do |pkg|
  package pkg
end # .each

# python 2.6 is required; CentOS 5.x needs to use python26 package
package 'python' do
  if platform_family?('rhel') && node['platform_version'].to_i == 5
    package_name 'python26'
  else
    package_name 'python'
  end # if
  action :install
end # package

# nodejs requires python 2.6; the symlink below allows #!/usr/bin/env python
# to use v2.6, provided /usr/local/bin comes before /usr/bin in $PATH
# action :create allows it to repair missing link
link '/usr/local/bin/python' do
  to    '/usr/bin/python26'
  owner 'root'
  group 'root'
  action :create
  only_if { platform_family?('rhel') && node['platform_version'].to_f < 6.0 }
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
    to    "../apps/#{node['rails_app']['name']}/#{stage['name']}/" +
      'current/public'
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

end # .each

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
directory '/home/jeeves/.ssh' do
  owner   'jeeves'
  group   'jeeves'
  mode    '0700'
end # directory

template '/home/jeeves/.ssh/config' do |t|
  owner   'jeeves'
  group   'jeeves'
  mode    '0644'
  variables(
    :header => node['file']['header'].gsub('@filename', t.name)
      .gsub('@hostname', node['hostname'])
  )
end # template

template '/home/jeeves/.ssh/matrix_deploy_key' do |t|
  source  'ssh_key.erb'
  owner   'jeeves'
  group   'jeeves'
  mode    '0600'
  variables(
    :header => node['file']['header'].gsub('@filename', t.name)
      .gsub('@hostname', node['hostname']),
    :private_key => secret['matrix_deploy_key']
  )
end # template
