#
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2014, Angry Cactus

include_recipe "build-essential"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "php"
include_recipe "memcached"
include_recipe "mysql::server"
include_recipe "mysql::client"

# PHP modules needed for drupal.
php_packages = %w{ libapache2-mod-php5 php5-gd php5-curl php5-memcache php5-imagick php5-mysql libpcre3-dev }
if node['platform_version'] == '14.04'
  php_packages << 'php5-apcu'
end
# Pear modules needed for drupal.
pear_modules = %w{ uploadprogress }

# Process PHP modules.
php_packages.each do |p|
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

pear_modules.each do |p|
    php_pear p do
        action :install
    end
end

# More pear modules with custom settings.
# only relevent for 12.04
if node['platform_version'] == '12.04'
  php_pear "apc" do
    action :install
    directives(:shm_size => '64M', :enable_cli => 0)
  end
end
