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
