# encoding: utf-8
require 'spec_helper'

describe 'rails_app::db' do
  # verify privileges for user 'mysqladmin@localhost'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--execute="show grants for mysqladmin@localhost;")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT ALL PRIVILEGES statement' do
      expect(subject.stdout).to include(
        "GRANT ALL PRIVILEGES ON *.* TO 'mysqladmin'@'localhost'"
      )
    end # it
  end # describe

  # verify privileges for user 'mysqladmin@%'
  describe command(cmd.join(' ').gsub('localhost', "'%'")) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT ALL PRIVILEGES statement' do
      expect(subject.stdout).to include(
        "GRANT ALL PRIVILEGES ON *.* TO 'mysqladmin'@'%'"
      )
    end # it
  end # describe

  # verify privileges for user 'insql@localhost'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--execute="show grants for insql@localhost;")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT USAGE statement' do
      expect(subject.stdout).to include(
        "GRANT USAGE ON *.* TO 'insql'@'localhost'"
      )
    end # it

    it 'returns expected GRANT SELECT statement' do
      expect(subject.stdout).to include(
        'GRANT SELECT, INSERT, UPDATE ON `matrix_production`.* ' \
        "TO 'insql'@'localhost'"
      )
    end # it
  end # describe

  # verify privileges for user 'insql@%'
  describe command(cmd.join(' ').gsub('localhost', "'%'")) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT USAGE statement' do
      expect(subject.stdout).to include(
        "GRANT USAGE ON *.* TO 'insql'@'%'"
      )
    end # it

    it 'returns expected GRANT SELECT statement' do
      expect(subject.stdout).to include(
        'GRANT SELECT, INSERT, UPDATE ON `matrix_production`.* ' \
        "TO 'insql'@'%'"
      )
    end # it
  end # describe

  # verify database encoding for database 'matrix_production'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--database=matrix_production)
  cmd << %q(--execute="show variables like 'character_set_database';")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected value (utf8)' do
      expect(subject.stdout).to include('utf8')
    end # it
  end # describe

  # verify database collation for database 'matrix_production'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--database=matrix_production)
  cmd << %q(--execute="show variables like 'collation_database';")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected value (utf8_general_ci)' do
      expect(subject.stdout).to include('utf8_general_ci')
    end # it
  end # describe

  # verify privileges for user 'matrix@localhost'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--execute="show grants for matrix@localhost;")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT USAGE statement' do
      expect(subject.stdout).to include(
        "GRANT USAGE ON *.* TO 'matrix'@'localhost'"
      )
    end # it

    it 'returns expected GRANT ALL PRIVILEGES statement' do
      expect(subject.stdout).to include(
        'GRANT ALL PRIVILEGES ON `matrix_production`.* ' \
        "TO 'matrix'@'localhost'"
      )
    end # it
  end # describe

  # verify database encoding for database 'matrix_staging'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--database=matrix_staging)
  cmd << %q(--execute="show variables like 'character_set_database';")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected value (utf8)' do
      expect(subject.stdout).to include('utf8')
    end # it
  end # describe

  # verify database collation for database 'matrix_staging'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--database=matrix_staging)
  cmd << %q(--execute="show variables like 'collation_database';")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected value (utf8_general_ci)' do
      expect(subject.stdout).to include('utf8_general_ci')
    end # it
  end # describe

  # verify privileges for user 'matrix_staging@localhost'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--execute="show grants for matrix_staging@localhost;")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT USAGE statement' do
      expect(subject.stdout).to include(
        "GRANT USAGE ON *.* TO 'matrix_staging'@'localhost'"
      )
    end # it

    it 'returns expected GRANT ALL PRIVILEGES statement' do
      expect(subject.stdout).to include(
        'GRANT ALL PRIVILEGES ON `matrix_staging`.* ' \
        "TO 'matrix_staging'@'localhost'"
      )
    end # it
  end # describe

  # verify privileges for user 'wwuser@%'
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--execute="show grants for wwuser@'%';")
  describe command(cmd.join(' ')) do
    it 'returns exit status 0' do
      expect(subject).to return_exit_status(0)
    end # it

    it 'returns expected GRANT USAGE statement' do
      expect(subject.stdout).to include(
        "GRANT USAGE ON *.* TO 'wwuser'@'%'"
      )
    end # it

    it 'returns expected GRANT SELECT statement' do
      expect(subject.stdout).to include(
        "GRANT SELECT ON `matrix_production`.* TO 'wwuser'@'%'"
      )
    end # it
  end # describe

  # ensure test database does not exist
  cmd = []
  cmd << %q(mysql --user=mysqladmin --password=mysqladmin_password)
  cmd << %q(--execute="use test;")
  describe command(cmd.join(' ')) do
    it 'returns exit status 1' do
      expect(subject).to return_exit_status(1)
    end # it

    it 'returns unknown database error' do
      expect(subject.stdout).to include(
        "Unknown database 'test'"
      )
    end # it
  end # describe

end # describe
