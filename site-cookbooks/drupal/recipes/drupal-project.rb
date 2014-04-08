#
# Cookbook Name:: drupal
# Recipe:: drupal-project
#
# Copyright 2014, Angry Cactus
#

include_recipe "drupal::default"
include_recipe "drupal::drush"

template "/etc/drush/drushrc.php" do
    source "drushrc.php.erb"
    owner "root"
    group "root"
    mode 0755
end

