#
# Cookbook Name:: drupal
# Recipe:: development
#
# Copyright 2014, Angry Cactus    

include_recipe "drupal::default"

php_pear "xhprof" do
    preferred_state "beta"
    action :install
end

php_pear "xdebug" do
    action :install
end

# php_pear zend_extensions doesn't work
template "/etc/php5/conf.d/xdebug.ini" do
    source "xdebug.ini.erb"
    owner "root"
    group "root"
    mode 0644
end

service "apache2" do
    action :restart
end

