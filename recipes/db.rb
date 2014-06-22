# encoding: utf-8
#
# Cookbook Name:: rails_app
# Recipe:: db
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

include_recipe 'mysql::ruby'
include_recipe 'chef-sugar'

# retrieve contents of encrypted data bag (refer to chef-repo/ENCRYPTED.md)
secret = encrypted_data_bag_item(:encrypted, node.chef_environment)

# establish database server connection parameters
connection_info = {
  :username => 'root',
  :host => 'localhost',
  :password => node['mysql']['server_root_password'] ||
    secret['mysql']['root']
}


# grant privileges to user 'mysqladmin' for super-user access
%w(localhost %).each do |domain|
  # mysql_database 'custom query' do
  #   connection connection_info
  #   sql <<-EOF
  #   GRANT ALL PRIVILEGES
  #   ON *.*
  #   TO `mysqladmin`@`#{domain}`
  #   IDENTIFIED BY PASSWORD '#{secret["mysqladmin"]}'
  #   WITH GRANT OPTION;
  #   EOF
  #   action :query
  #   only_if { secret['mysqladmin'] }
  # end
  mysql_database_user "mysqladmin@#{domain}" do
    connection  connection_info
    username    'mysqladmin'
    host        domain
    password    secret['mysqladmin'] || 'missing_password'
    with_option ['GRANT OPTION']
    # with_option ['GRANT OPTION', 'MAX_QUERIES_PER_HOUR 60',
    #   'MAX_UPDATES_PER_HOUR 75', 'MAX_CONNECTIONS_PER_HOUR 90',
    #   'MAX_USER_CONNECTIONS 5']
    action      :grant
    only_if     { secret['mysqladmin'] }
  end # mysql_database_user


  # grant privileges to 'insql' for internal, read/write access to The Matrix
  mysql_database_user "insql@#{domain}" do
    connection    connection_info
    username      'insql'
    host          domain
    password      secret['insql'] || 'missing_password'
    database_name 'matrix_production'
    privileges    %w(SELECT INSERT UPDATE)
    action        :grant
    only_if       { secret['insql'] }
  end # mysql_database_user
end # .each


# use fetch method to fail if key is missing
node['rails_app']['stages'].each do |stage|
  # create <stage> database
  mysql_database stage.fetch('db_database') do
    connection  connection_info
    encoding    stage.fetch('db_encoding')
    collation   stage.fetch('db_collation')
  end # mysql_database

  # grant privileges to <db_username> for Rails <stage> environment
  mysql_database_user "#{stage.fetch('name')}_" \
    "#{stage.fetch('db_username')}@#{stage.fetch('db_host')}" do
    connection    connection_info
    username      stage.fetch('db_username')
    host          stage.fetch('db_host')
    password      secret[stage.fetch('db_username')] || 'missing_password'
    database_name stage.fetch('db_database')
    action        :grant
    only_if       { secret[stage.fetch('db_username')] }
  end # mysql_database_user

end # .each

# # create production, staging databases
# %w(matrix_production matrix_staging).each do |database|
#   mysql_database database do
#     connection connection_info
#     encoding 'utf8'
#     collation 'utf8_general_ci'
#   end # mysql_database database
# end # .each


# # grant privileges to 'matrix' for Rails production environment
# mysql_database_user 'matrix' do
#   connection connection_info
#   password secret['matrix']
#   database_name 'matrix_production'
#   host 'localhost'
#   action :grant
#   only_if { secret['matrix'] }
# end # mysql_database_user


# # grant privileges to 'matrix_staging' for Rails staging environment
# mysql_database_user 'matrix_staging' do
#   connection connection_info
#   password secret['matrix_staging']
#   database_name 'matrix_staging'
#   host 'localhost'
#   action :grant
#   only_if { secret['matrix_staging'] }
# end # mysql_database_user


# grant privileges to 'wwuser' for internal, read-only access to The Matrix
mysql_database_user 'wwuser' do
  connection    connection_info
  password      secret['wwuser'] || 'missing_password'
  host          '%'
  database_name 'matrix_production'
  privileges    ['SELECT']
  action        :grant
  only_if       { secret['wwuser'] }
end # mysql_database_user


# drop test database
mysql_database 'test' do
  connection  connection_info
  action      :drop
end # mysql_database
