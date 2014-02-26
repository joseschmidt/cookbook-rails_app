# encoding: utf-8
require 'spec_helper'

describe 'rails_app::web' do
  before do
    Chef::Sugar::DataBag.stub(:encrypted_data_bag_item).and_return(
      'stage1_db_username' => 'stage1_db_password',
      'stage2_db_username' => 'stage2_db_password'
    )
  end # before

  [
    { :platform => 'centos', :version => '5.9' },
    { :platform => 'centos', :version => '6.5' },
    { :platform => 'redhat', :version => '5.9' },
    { :platform => 'redhat', :version => '6.5' },
    { :platform => 'ubuntu', :version => '12.04' }
  ].each do |i|
    context "#{i[:platform]}/#{i[:version]}" do
      cached(:chef_run) do
        ChefSpec::Runner.new(i) do |node|
          # create a new environment
          env = Chef::Environment.new
          env.name 'qa'

          # stub the node to return this environment
          node.stub(:chef_environment).and_return(env.name)

          # stub any calls to Environment.load to return this environment
          Chef::Environment.stub(:load).and_return(env)

          # override cookbook attributes
          node.set['file']['header'] = 'node.file.header'
          node.set['rails_app']['name'] = 'whiz_bang_app'
          node.set['rails_app']['stages'] = [
            {
              'name'                    => 'stage1',
              'codename'                => 'st1',
              'db_port'                 => 'stage1_db_port',
              'db_database'             => 'stage1_db_database',
              'db_username'             => 'stage1_db_username',
              'db_encoding'             => 'stage1_db_utf8',
              'db_collation'            => 'stage1_db_utf8_general_ci',
              'db_host'                 => 'stage1_db_localhost'
            },
            {
              'name'                    => 'stage2',
              'codename'                => 'st2',
              'db_port'                 => 'stage2_db_port',
              'db_database'             => 'stage2_db_database',
              'db_username'             => 'stage2_db_username',
              'db_encoding'             => 'stage2_db_utf8',
              'db_collation'            => 'stage2_db_utf8_general_ci',
              'db_host'                 => 'stage2_db_localhost'
            }
          ]

          # # required for build-essential cookbook on travis-ci
          # node.set['platform_family'] = 'rhel'
        end.converge(described_recipe)
      end # cached

      describe 'chef-sugar::default' do
        it 'includes recipe' do
          expect(chef_run).to include_recipe(subject)
        end # it
      end # describe

      describe 'yum::epel' do
        it 'includes recipe if platform family is rhel' do
          if platform?(:rhel)
            expect(chef_run).to include_recipe(subject)
          else
            expect(chef_run).to_not include_recipe(subject)
          end # if
        end # it
      end # describe

      describe 'unixODBC-devel' do
        it 'installs package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      %w(freetds freetds-devel).each do |pkg|
        describe pkg do
          it 'installs package' do
            expect(chef_run).to install_package(subject)
          end # it
        end # describe
      end # %w(...).each

      it 'installs expected package' do
        if platform?(:rhel5)
          expect(chef_run).to install_package('python')
            .with_package_name('python26')
        else
          expect(chef_run).to install_package('python')
            .with_package_name('python')
        end # if
      end # it

      describe '/usr/local/bin/python' do
        it 'creates link with expected owner, group' do
          if platform?(:rhel5)
            expect(chef_run).to create_link(subject)
              .with(:owner => 'root', :group => 'root')
          else
            expect(chef_run).to_not create_link(subject)
          end # if
        end # it
      end # describe

      describe 'jeeves' do
        it 'creates user' do
          expect(chef_run).to create_user(subject)
        end # it
      end # describe

      describe '/var/www/html' do
        it 'creates directory with expected owner, group, mode' do
          expect(chef_run).to create_directory(subject)
            .with(:owner => 'root', :group => 'root', :mode => '0755')
        end # it
      end # describe

      %w(st1 st2).each do |codename|
        describe "/var/www/html/#{codename}" do
          it 'creates link with expected owner, group' do
            expect(chef_run).to create_link(subject)
              .with(:owner => 'root', :group => 'root')
          end # it
        end # describe
      end # %w(...).each

      %w(stage1 stage2).each do |name|
        base = "/var/www/apps/whiz_bang_app/#{name}"

        describe "#{base}/shared/config" do
          it 'creates directory with expected owner, group, mode' do
            expect(chef_run).to create_directory(subject)
              .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0755')
          end # it
        end # describe

        describe "#{base}/current" do
          it 'creates link with expected owner, group' do
            expect(chef_run).to create_link(subject)
              .with(:owner => 'jeeves', :group => 'jeeves')
          end # it
        end # describe

        describe "#{base}/current/REVISION" do
          it 'creates file with expected owner, group, mode' do
            expect(chef_run).to create_file_if_missing(subject)
              .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0755')
          end # it
        end # describe

        describe "#{base}/shared/config/database.yml" do
          it 'creates template with expected owner, group, mode' do
            expect(chef_run).to create_template(subject)
              .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0600')
          end # it

          it 'renders file with expected stage name' do
            expect(chef_run).to render_file(subject)
            .with_content("#{name}:")
          end # it

          it 'renders file with expected port' do
            expect(chef_run).to render_file(subject)
              .with_content("port: #{name}_db_port")
          end # it

          it 'renders file with expected database' do
            expect(chef_run).to render_file(subject)
              .with_content("database: #{name}_db_database")
          end # it

          it 'renders file with expected username' do
            expect(chef_run).to render_file(subject)
              .with_content("username: #{name}_db_username")
          end # it

          it 'renders file with expected password' do
            expect(chef_run).to render_file(subject)
              .with_content("password: #{name}_db_password")
          end # it
        end # describe
      end # %w(...).each

      describe 'chown -R jeeves:jeeves /var/www/apps/whiz_bang_app' do
        it 'adjusts permissions to expected owner, group' do
          expect(chef_run).to run_execute(subject)
        end # it
      end # describe

      describe '/etc/logrotate.d/var_www_apps' do
        it 'creates template with expected owner, group, mode' do
          expect(chef_run).to create_template(subject)
            .with(:owner => 'root', :group => 'root', :mode => '0644')
        end # it

        it 'renders file with expected path' do
          expect(chef_run).to render_file(subject)
            .with_content('/var/www/apps/**/**/shared/log/*.log')
        end # it

        it 'renders file with expected frequency' do
          expect(chef_run).to render_file(subject)
            .with_content('daily')
        end # it

        it 'renders file with expected rotate limit' do
          expect(chef_run).to render_file(subject)
            .with_content('rotate 30')
        end # it

        it 'renders file with expected options (missingok)' do
          expect(chef_run).to render_file(subject)
            .with_content('missingok')
        end # it

        it 'renders file with expected options (compress)' do
          expect(chef_run).to render_file(subject)
            .with_content('compress')
        end # it

        it 'renders file with expected options (delaycompress)' do
          expect(chef_run).to render_file(subject)
            .with_content('delaycompress')
        end # it

        it 'renders file with expected options (sharedscripts)' do
          expect(chef_run).to render_file(subject)
            .with_content('sharedscripts')
        end # it

        it 'renders file with expected postrotate command' do
          expect(chef_run).to render_file(subject)
            .with_content('touch /var/www/apps/**/**/current/tmp/restart.txt')
        end # it
      end # describe

      describe '/home/jeeves/.ssh' do
        it 'creates directory with expected owner, group, mode' do
          expect(chef_run).to create_directory(subject)
            .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0700')
        end # it
      end # describe

      describe '/home/jeeves/.ssh/config' do
        it 'creates template with expected owner, group, mode' do
          expect(chef_run).to create_template(subject)
            .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0644')
        end # it

        it 'renders file with expected header' do
          expect(chef_run).to render_file(subject)
            .with_content('node.file.header')
        end # it
      end # describe

      describe '/home/jeeves/.ssh/matrix_deploy_key' do
        it 'creates template with expected owner, group, mode' do
          expect(chef_run).to create_template(subject)
            .with(:owner => 'jeeves', :group => 'jeeves', :mode => '0600')
        end # it

        it 'renders file with expected header' do
          expect(chef_run).to render_file(subject)
            .with_content('node.file.header')
        end # it
      end # describe

    end # context
  end # [...].each

end # describe
