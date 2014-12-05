#
# Cookbook Name:: drupal
# Recipe:: development
#
# Copyright 2014, Angry Cactus    

include_recipe "drupal::default"

if node['platform_version'] == '12.04'
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
else 
  if node['platform_version'] == '14.04'
    php_packages = %w{ php5-xhprof php5-xdebug }
    php_packages.each do |p|
      package p do
        action :install
      end
    end
  end
end

service "apache2" do
    action :restart
end
