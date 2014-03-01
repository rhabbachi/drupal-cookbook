#
# Cookbook Name:: drupal
# Recipe:: dependencies
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "drupal::default"
include_recipe "drupal::drush"

template "/etc/drush/drushrc.php" do
    source "drushrc.php.erb"
    owner "root"
    group "root"
    mode 0755
end

