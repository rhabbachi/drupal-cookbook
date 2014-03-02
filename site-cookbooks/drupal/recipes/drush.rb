#
# Cookbook Name:: drupal
# Recipe:: dependencies
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "drupal::default"

directory "/opt/composer" do
    owner "root"
    group "root"
    mode 00644
    action :create
end

execute 'curl -sS https://getcomposer.org/installer | php' do
    cwd '/opt/composer'
end

execute 'mv composer.phar /usr/local/bin/composer' do
    cwd '/opt/composer'
end

git node['drush']['install_dir'] do
    repository "https://github.com/drush-ops/drush.git"
    reference node['drush']['version']
    action :sync
end

link "/usr/bin/drush" do
    to "#{node['drush']['install_dir']}/drush"
end

execute 'composer install' do
    cwd node['drush']['install_dir']
end

# php_pear is only working for PECL packages
execute "pear upgrade Console_Table"

directory "/etc/drush" do
    owner "root"
    group "root"
    mode 0755
    action :create
end

