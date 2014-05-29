#
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2014, Angry Cactus
#
# Setup backup strategy for the drupal site using drush archive.

include_recipe 'drupal::drush'
include_recipe 'python::pip'
include_recipe 'cron'

# Install dependency needed for duplicity
duplicity_deps = %w{ rsync ncftp lftp tahoe-lafs duplicity python-cloudfiles }

duplicity_deps.each do |dep|
  package dep do
    action :install
  end
end

python_pkgs = %w{ paramiko urllib3 oauthlib boto gdata python-swiftclient }

python_pkgs.each do |dep|
  python_pip dep do
    action :install
  end
end

# Prepare backup location.
backup_source = "#{ node['drupal']['backup']['source']}"
directory backup_source do
  owner 'root'
  group 'root'
  mode '0700'
  recursive true
  action :create
end

# Duply setup
cookbook_file '/usr/bin/duply' do
  source "duply"
  owner "root"
  group "root"
  mode 0755
  action :create
end

directory "/etc/duply/#{ node['drupal']['name'] }" do
  recursive true
  owner 'root'
  group 'root'
  # Permmissions as required by duply
  mode '0700'
  action :create
end

duply_conf_root = "/etc/duply/#{ node['drupal']['name'] }"
duply_conf = "#{ duply_conf_root }/conf"

log "Creating duply configuration"

log "using target: #{ node['drupal']['backup']['target_s3'] }"
#target_s3 = data_bag_item('targets', "#{ node['drupal']['backup']['target_s3'] }")
s3 = data_bag_item('targets', 'test')
backup_target = "s3://#{s3['aws_access_key_id']}:#{s3['aws_secret_access_key']}@#{s3['host']}/#{s3['bucket']}"

template duply_conf do
  source "duply.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :target => "#{ backup_target }",
    :source => "#{ backup_source }"
  })
end

backup_cmd = "duply #{ node['drupal']['name'] } backup > /var/log/duply.log 2>&1"

cron_d "chef_backup_#{ node['drupal']['name'] }" do
  minute "#{ node['drupal']['backup']['minute'] }"
  day "#{ node['drupal']['backup']['daily'] }"
  hour "#{ node['drupal']['backup']['hourly'] }"
  month "#{ node['drupal']['backup']['monthly'] }"
  weekday "#{ node['drupal']['backup']['weekday'] }" 
  command backup_cmd
  action :create
end

# Setup pre/post scripts
duply_conf_pre = "#{ duply_conf_root }/pre"

unless node['drupal']['druploy_enabled'] then
  ## PRE script
  template duply_conf_pre do
    source "duply.pre.erb"
    owner "root"
    group "root"
    mode 0544
  end
  ## POST script
end


