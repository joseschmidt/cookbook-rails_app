README
======

This document describes how to use chef-zero to access data from the `test/integration` directory.


Data Bags
---------

Display contents of [`encrypted/qa`](data_bags/encrypted/qa.json) data bag:

````bash
$ knife data bag show encrypted qa --local-mode --format json --secret-file encrypted_data_bag_secret

WARN: No cookbooks directory found at or above current directory.  Assuming /.../cookbook-automysqlbackup/test/integration.
{
  "id": "qa",
  "insql": "insql_password",
  "matrix": "matrix_password",
  "matrix_deploy_key": "PrIvAtE kEy",
  "matrix_staging": "matrix_staging_password",
  "mysql": {
    "root": "root_password"
  },
  "mysqladmin": "mysqladmin_password",
  "wwuser": "wwuser_password"
}
````

Edit [`encrypted/qa`](data_bags/encrypted/qa.json) data bag (opens separate editor window):
````bash
$ knife data bag edit encrypted qa --local-mode --secret-file encrypted_data_bag_secret
````

Create new [`encrypted_data_bag_secret`](encrypted_data_bag_secret) (**WARNING**: modifications to `encrypted_data_bag_secret` will render existing encrypted data bags unreadable):

````bash
$ openssl rand -base64 512 | tr -d '\r\n' > encrypted_data_bag_secret
````

Create new `encrypted/qa` data bag (opens separate editor window):
````bash
$ knife data bag create encrypted qa --local-mode --secret-file encrypted_data_bag_secret
````


Environments
------------

Display contents of [`qa`](environments/qa.json) environment:

````bash
$ knife environment show qa --local-mode --format json

WARN: No cookbooks directory found at or above current directory.  Assuming /.../cookbook-automysqlbackup/test/integration.
{
  "name": "qa",
  "description": "QA environment for test-kitchen",
  "cookbook_versions": {
  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {
  },
  "override_attributes": {
  }
}
````

Edit [`qa`](environments/qa.json) environment (opens separate editor window):
````bash
$ knife environment edit qa --local-mode
````
