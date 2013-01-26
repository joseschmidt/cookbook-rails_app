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
include_recipe 'helpers'

# retrieve contents of encrypted data bag (refer to chef-repo/ENCRYPTED.md)
secret = decrypt_data_bag(:encrypted)

# establish database server connection parameters
connection_info = {
  :host => 'localhost',
  :username => 'root',
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
  mysql_database_user 'mysqladmin' do
    connection connection_info
    password secret['mysqladmin']
    host domain
    with_option ['GRANT OPTION']
    # with_option ['GRANT OPTION', 'MAX_QUERIES_PER_HOUR 60',
    #   'MAX_UPDATES_PER_HOUR 75', 'MAX_CONNECTIONS_PER_HOUR 90',
    #   'MAX_USER_CONNECTIONS 5']
    action :grant
    only_if { secret['mysqladmin'] }
  end # mysql_database_user 'mysqladmin'
end # %w(localhost %).each


# use fetch method to fail if key is missing
node['rails_app']['stages'].each do |stage|
  # create <stage> database
  mysql_database stage.fetch('db_database') do
    connection  connection_info
    encoding    stage.fetch('db_encoding')
    collation   stage.fetch('db_collation')
  end # mysql_database
  
  # grant privileges to <db_username> for Rails <stage> environment
  mysql_database_user stage.fetch('db_username') do
    connection    connection_info
    password      secret[stage.fetch('db_username')]
    database_name stage.fetch('db_database')
    host          stage.fetch('db_host')
    action        :grant
    only_if { secret[stage.fetch('db_username')] }
  end # mysql_database_user
  
end # node['rails_app']['stages'].each

# # create production, staging databases
# %w(matrix_production matrix_staging).each do |database|
#   mysql_database database do
#     connection connection_info
#     encoding 'utf8'
#     collation 'utf8_general_ci'
#   end # mysql_database database
# end # %w(matrix_production matrix_staging).each


# # grant privileges to 'matrix' for Rails production environment
# mysql_database_user 'matrix' do
#   connection connection_info
#   password secret['matrix']
#   database_name 'matrix_production'
#   host 'localhost'
#   action :grant
#   only_if { secret['matrix'] }
# end # mysql_database_user 'matrix'


# # grant privileges to 'matrix_staging' for Rails staging environment
# mysql_database_user 'matrix_staging' do
#   connection connection_info
#   password secret['matrix_staging']
#   database_name 'matrix_staging'
#   host 'localhost'
#   action :grant
#   only_if { secret['matrix_staging'] }
# end # mysql_database_user 'matrix_staging'


# grant privileges to 'wwuser' for internal, read-only access to The Matrix
mysql_database_user 'wwuser' do
  connection    connection_info
  password      secret['wwuser']
  database_name 'matrix_production'
  host          '%'
  privileges    ['SELECT']
  action        :grant
  only_if { secret['wwuser'] }
end # mysql_database_user


# drop test database
mysql_database 'test' do
  connection  connection_info
  action      :drop
end # mysql_database
