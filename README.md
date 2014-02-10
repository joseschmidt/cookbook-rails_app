rails_app Cookbook
==================
[![Build Status](https://travis-ci.org/jhx/cookbook-rails_app.png?branch=master)](https://travis-ci.org/jhx/cookbook-rails_app)

Installs support packages and symlinks for the Rails app.


Requirements
------------
### Cookbooks
The following cookbooks are direct dependencies because they're used for common "default" functionality.

- `chef-sugar`
- `cron`
- `database`
- `logrotate`
- `mysql`
- `rvm`
- `yum`

### Platforms
The following platforms are supported and tested under Test Kitchen:

- CentosOS 5.10, 6.5

Other RHEL family distributions are assumed to work. See [TESTING](TESTING.md) for information about running tests in Opscode's Test Kitchen.


Attributes
----------
Refer to [`attributes/default.rb`](attributes/default.rb) for default values.

- `node['rails_app']['name']` - name of Rails app
- `node['rails_app']['rails']['version]` - version of Rails gem (not currently used in this cookbook)
- `node['rails_app']['stages']` - options hash to configure database


Recipes
-------
This cookbook provides one main recipe for configuring a node.

- `db.rb` - *Use this recipe* to install and configure Rails app database server.
- `web.rb` - *Use this recipe* to install and configure Rails app webserver.

### db
This recipe creates and configures databases and database users.

### default
This recipe is a no-op.

### web
This recipe installs required packages and symlinks for the Rails app webserver.


Usage
-----
On client nodes, use the following recipes:

````javascript
{ "run_list": ["recipe[rails_app::db]", "recipe[rails_app::web]"] }
````

The following are the key items achieved by this cookbook:

- creates required databases and database users
- installs YUM EPEL repository
- installs required support packages
- creates required symlinks for Rails app webserver
- installs `logrotate` configuration file
- configures SSH access for deploy user


License & Authors
-----------------
- Author:: Doc Walker (<doc.walker@jameshardie.com>)

````text
Copyright 2013-2014, James Hardie Building Products, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
````
