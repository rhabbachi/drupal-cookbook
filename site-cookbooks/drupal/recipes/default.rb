#
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

include_recipe "build-essential"
include_recipe "sudo"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "php"
include_recipe "memcached"
include_recipe "mysql::server"
include_recipe "mysql::client"

%w{ git }.each do |p|
    package p do
        action :install
    end
end

# Utilities
%w{ tree }.each do |p|
    package p do
        action :install
    end
end

# Drupal environment
%w{ libapache2-mod-php5 php5-curl php5-memcache php5-imagick php5-mysql libpcre3-dev }.each do |p|
    package p do
        action :install
    end
end

# Prepare PEAR/PECL
php_pear_channel 'pear.php.net' do
    action :update
end

php_pear_channel 'pecl.php.net' do
    action :update
end

%w{ uploadprogress }.each do |p|
    php_pear p do
        action :install
    end
end

php_pear "apc" do
    action :install
    directives(:shm_size => '64M', :enable_cli => 0)
end

