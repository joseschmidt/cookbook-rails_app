# coding: utf-8
#
# Cookbook Name:: rails_app
# Attributes:: default
#

default['rails_app']['name']                  = 'matrix'

# gem ruby-odbc-0.99994 requires unixODBC-devel
#     tiny_tds-0.5.1    requires freetds, freetds-devel
# nodejs requires python26
default['rails_app']['packages'] = %w(
  unixODBC-devel freetds freetds-devel python26
)

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

default['rails_app']['deploy']['remote_bind_address'] = '10.201.0.1'
default['rails_app']['deploy']['remote_login'] = 'pigorfish@wvfans.net'
default['rails_app']['deploy']['nodes'] = {
  'phimatrix' => { 22 => 10201, 80 => 10801 },
  'rshmatrix' => { 22 => 10202, 80 => 10802 },
  'cpkmatrix' => { 22 => 10203, 80 => 10803 },
  'nzlmatrix' => { 22 => 10204, 80 => 10804 },
  'tapmatrix' => { 22 => 10211, 80 => 10811 },
  'renmatrix' => { 22 => 10212, 80 => 10812 },
  'fnpmatrix' => { 22 => 10213, 80 => 10813 },
  'clpmatrix' => { 22 => 10214, 80 => 10814 },
  'waxmatrix' => { 22 => 10215, 80 => 10815 },
  'pepmatrix' => { 22 => 10216, 80 => 10816 },
  'pcpmatrix' => { 22 => 10217, 80 => 10817 },
  'vapmatrix' => { 22 => 10218, 80 => 10818 },
  'matrix'    => { 22 => 10221, 80 => 10821 },
  'devmatrix' => { 22 => 10222, 80 => 10822 },
  'jhx_client' => { 22 => 10223, 80 => 10823 }
}
