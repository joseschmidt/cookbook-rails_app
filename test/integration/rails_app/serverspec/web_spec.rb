# encoding: utf-8
require 'spec_helper'

describe 'rails_app::web' do
  describe yumrepo('epel') do
    it 'exists' do
      expect(subject).to exist
    end # it

    it 'is enabled' do
      expect(subject).to be_enabled
    end # it
  end # describe

  describe package('unixODBC-devel') do
    it 'is installed' do
      expect(subject).to be_installed
    end # it
  end # describe

  describe package('freetds') do
    it 'is installed' do
      expect(subject).to be_installed
    end # it
  end # describe

  describe package('freetds-devel') do
    it 'is installed' do
      expect(subject).to be_installed
    end # it
  end # describe

  os = backend(Serverspec::Commands::Base).check_os
  if os[:family] == 'RedHat' && os[:release].to_f < 6.0
    describe package('python26') do
      it 'is installed with version 2.6' do
        expect(subject).to be_installed.with_version('2.6')
      end # it
    end # describe

    describe file('/usr/local/bin/python') do
      it 'is mode 777' do
        expect(subject).to be_mode('777')
      end # it

      it 'is owned by root' do
        expect(subject).to be_owned_by('root')
      end # it

      it 'is grouped into root' do
        expect(subject).to be_grouped_into('root')
      end # it

      it 'is linked to python26 binary' do
        expect(subject).to be_linked_to('/usr/bin/python26')
      end # it
    end # describe
  else
    describe package('python') do
      it 'is installed with version 2.6' do
        expect(subject).to be_installed.with_version('2.6')
      end # it
    end # describe
  end # if

  describe file('/var/www/html/neo') do
    it 'is mode 777' do
      expect(subject).to be_mode('777')
    end # it

    it 'is owned by root' do
      expect(subject).to be_owned_by('root')
    end # it

    it 'is grouped into root' do
      expect(subject).to be_grouped_into('root')
    end # it

    it 'is relative-linked to production public directory' do
      expect(subject).to be_linked_to(
        '../apps/matrix/production/current/public'
      )
    end # it
  end # describe

  production_base = '/var/www/apps/matrix/production'
  describe file("#{production_base}/shared/config") do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode('755')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it
  end # describe

  describe file("#{production_base}/current") do
    it 'is mode 777' do
      expect(subject).to be_mode('777')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it

    it 'is linked to /tmp directory' do
      expect(subject).to be_linked_to('/tmp')
    end # it
  end # describe

  describe file("#{production_base}/current/REVISION") do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode('755')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it
  end # describe

  describe file("#{production_base}/shared/config/database.yml") do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is mode 600' do
      expect(subject).to be_mode('600')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it

    it 'includes expected stage' do
      expect(subject.content).to include('production:')
    end # it

    it 'includes expected port' do
      expect(subject.content).to include('port: 3306')
    end # it

    it 'includes expected database' do
      expect(subject.content).to include('database: matrix_production')
    end # it

    it 'includes expected username' do
      expect(subject.content).to include('username: matrix')
    end # it

    it 'includes expected password' do
      expect(subject.content).to include('password: matrix_password')
    end # it
  end # describe

  staging_base = '/var/www/apps/matrix/staging'
  describe file("#{staging_base}/shared/config") do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode('755')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it
  end # describe

  describe file("#{staging_base}/current") do
    it 'is mode 777' do
      expect(subject).to be_mode('777')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it

    it 'is linked to /tmp directory' do
      expect(subject).to be_linked_to('/tmp')
    end # it
  end # describe

  describe file("#{staging_base}/current/REVISION") do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode('755')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it
  end # describe

  describe file("#{staging_base}/shared/config/database.yml") do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is mode 600' do
      expect(subject).to be_mode('600')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it

    it 'includes expected stage' do
      expect(subject.content).to include('staging:')
    end # it

    it 'includes expected port' do
      expect(subject.content).to include('port: 3306')
    end # it

    it 'includes expected database' do
      expect(subject.content).to include('database: matrix_staging')
    end # it

    it 'includes expected username' do
      expect(subject.content).to include('username: matrix_staging')
    end # it

    it 'includes expected password' do
      expect(subject.content).to include('password: matrix_staging_password')
    end # it
  end # describe

  describe file('/var/www/apps/matrix') do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode('755')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it
  end # describe

  describe file('/etc/logrotate.d/var_www_apps') do
    it 'is file' do
      expect(subject).to be_file
    end # it

    it 'is owned by root' do
      expect(subject).to be_owned_by('root')
    end # it

    it 'is in group root' do
      expect(subject).to be_grouped_into('root')
    end # it

    it 'is mode 440' do
      expect(subject).to be_mode(440)
    end # it

    it 'includes expected path' do
      expect(subject.content).to include(
        '/var/www/apps/**/**/shared/log/*.log'
      )
    end # it

    it 'includes expected frequency' do
      expect(subject.content).to include('daily')
    end # it

    it 'includes expected rotate limit' do
      expect(subject.content).to include('rotate 30')
    end # it

    it 'includes expected options (missingok)' do
      expect(subject.content).to include('missingok')
    end # it

    it 'includes expected options (compress)' do
      expect(subject.content).to include('compress')
    end # it

    it 'includes expected options (delaycompress)' do
      expect(subject.content).to include('delaycompress')
    end # it

    it 'includes expected options (sharedscripts)' do
      expect(subject.content).to include('sharedscripts')
    end # it

    it 'includes expected postrotate command' do
      expect(subject.content).to include(
        'touch /var/www/apps/**/**/current/tmp/restart.txt'
      )
    end # it
  end # describe

  describe file('/home/jeeves/.ssh') do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is mode 700' do
      expect(subject).to be_mode('700')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it
  end # describe

  describe file('/home/jeeves/.ssh/config') do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is mode 644' do
      expect(subject).to be_mode('644')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it

    it 'includes expected identityfile' do
      expect(subject.content).to include(
        'identityfile ~/.ssh/matrix_deploy_key'
      )
    end # it
  end # describe

  describe file('/home/jeeves/.ssh/matrix_deploy_key') do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is mode 600' do
      expect(subject).to be_mode('600')
    end # it

    it 'is owned by jeeves' do
      expect(subject).to be_owned_by('jeeves')
    end # it

    it 'is grouped into jeeves' do
      expect(subject).to be_grouped_into('jeeves')
    end # it

    it 'includes expected private key' do
      expect(subject.content).to include(
        'PrIvAtE kEy'
      )
    end # it
  end # describe

end # describe
