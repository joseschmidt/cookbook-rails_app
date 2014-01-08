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
  'phimatrix' => { 22 => 10_201, 80 => 10_801 },
  'rshmatrix' => { 22 => 10_202, 80 => 10_802 },
  'cpkmatrix' => { 22 => 10_203, 80 => 10_803 },
  'nzlmatrix' => { 22 => 10_204, 80 => 10_804 },
  'tapmatrix' => { 22 => 10_211, 80 => 10_811 },
  'renmatrix' => { 22 => 10_212, 80 => 10_812 },
  'fnpmatrix' => { 22 => 10_213, 80 => 10_813 },
  'clpmatrix' => { 22 => 10_214, 80 => 10_814 },
  'waxmatrix' => { 22 => 10_215, 80 => 10_815 },
  'pepmatrix' => { 22 => 10_216, 80 => 10_816 },
  'pcpmatrix' => { 22 => 10_217, 80 => 10_817 },
  'vapmatrix' => { 22 => 10_218, 80 => 10_818 },
  'matrix'    => { 22 => 10_221, 80 => 10_821 },
  'devmatrix' => { 22 => 10_222, 80 => 10_822 },
  'jhx_client' => { 22 => 10_223, 80 => 10_823 }
}
