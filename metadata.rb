# encoding: utf-8
name              'rails_app'
maintainer        'James Hardie Building Products, Inc.'
maintainer_email  'doc.walker@jameshardie.com'
description       'Installs support packages and symlinks for the Rails app'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license           'Apache 2.0'
version           '0.4.0'

#--------------------------------------------------------------------- recipes
recipe            'rails_app',
                  'Recipe is a no-op'
recipe            'rails_app::db',
                  'Creates and configures databases and database users'
recipe            'rails_app::web',
                  'Installs required packages and symlinks for the ' \
                  'Rails app webserver'

#------------------------------------------------------- cookbook dependencies
depends           'chef-sugar', '~> 1.1.0'
depends           'cron', '~> 1.2.2'
depends           'database', '~> 1.3.10'
depends           'logrotate', '~> 1.5.0'
depends           'mysql', '~> 2.1.0'
depends           'rvm'
depends           'yum-epel'

#--------------------------------------------------------- supported platforms
# tested
supports          'centos'

# platform_family?('rhel'): not tested, but should work
supports          'amazon'
supports          'oracle'
supports          'redhat'
supports          'scientific'

# platform_family?('debian'): not tested, but may work
supports          'debian'
supports          'ubuntu'
