#
# Cookbook Name:: drupal
# Recipe:: dependencies
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "drupal::default"

git node['drush']['install_dir'] do
    repository "https://github.com/drush-ops/drush.git"
    reference node['drush']['version']
    action :sync
end

link "/usr/bin/drush" do
    to "#{node['drush']['install_dir']}/drush"
end

# php_pear is only working for PECL packages
execute "pear upgrade Console_Table"

directory "/etc/drush" do
    owner "root"
    group "root"
    mode 0755
    action :create
end

