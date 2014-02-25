# encoding: utf-8
#
# Cookbook Name:: rails_app
# Attributes:: default
#

default['rails_app']['name']                  = 'matrix'
default['rails_app']['rails']['version']      = '3.2.11'
default['rails_app']['stages'] = [
  {
    'name'                    => 'production',
    'codename'                => 'neo',
    'passenger_min_instances' => 8,
    'db_port'                 => 3306,
    'db_database'             => 'matrix_production',
    'db_username'             => 'matrix',
    'db_encoding'             => 'utf8',
    'db_collation'            => 'utf8_general_ci',
    'db_host'                 => 'localhost'
  },
  {
    'name'                    => 'staging',
    'codename'                => 'morpheus',
    'passenger_min_instances' => 1,
    'db_port'                 => 3306,
    'db_database'             => 'matrix_staging',
    'db_username'             => 'matrix_staging',
    'db_encoding'             => 'utf8',
    'db_collation'            => 'utf8_general_ci',
    'db_host'                 => 'localhost'
  }
]
