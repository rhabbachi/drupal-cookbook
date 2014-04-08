#
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2014, Angry Cactus

include_recipe 'varnish'
include_recipe 'drupal::drush'
include_recipe 'conf'

# Import varnish attributes
node.default['varnish']['listen_port'] = node['drupal']['varnish']['port'] 

# TODO This don't belong here
node.default['apache']['listen_ports'] = node['drupal']['http']['ports']

inc_file = "varnish.inc"
inc_code = "if(file_exists('./#{inc_file}')){inc_once('./#{inc_file}');}"

# Install and enable the module.
execute "download-varnish-module" do
  cwd "#{ node['drupal']['root'] }"
  command "drush dl -y varnish --destination=sites/all/modules/contrib/;"
  not_if "drush pml --no-core --type=module | grep varnish"
end

execute "enable-varnish-module" do
  cwd "#{ node['drupal']['root'] }"
  command "drush en -y varnish;"
  not_if "drush pml --no-core --type=module --status=enabled | grep varnish"
end

node['drupal']['sites'].each do |site|
  site_path = "#{ node['drupal']['root'] }/sites/#{ site }"

  conf_plain_file "#{ site_path }/settings.php" do
    pattern (/#{ inc_code }/)
    new_line "\n## Chef Drupal::Varnish ##\n#{inc_code}\n## Chef Drupal::Varnish ##"
    action :insert_if_no_match
  end

  template "#{ inc_file }" do
    path "#{ site_path }/#{inc_file}"
    mode 0644
    user "#{node['drupal']['user']}"
    group "#{ node['apache']['group']}"
    action :create
  end
end

## Workaround for varnish cookbook limitation.
#TODO fix opscode varnish cookbook
varnish_version = `apt-cache show --installed varnish | grep "Version" | cut -c10`
varnish_control_key = `cat #{ node['varnish']['secret_file'] }`
varnish_control_terminal = "#{ node['varnish']['admin_listen_address']}:#{
node['varnish']['admin_listen_port']}"

log "varnish module configuration" do
  message "varnish config: #{ varnish_version }|#{ varnish_control_key }|#{ varnish_control_terminal }"
  level :debug
end

# Set module versions as cookbook configuration.
execute "configure-varnish-module-version" do
  cwd "#{ node['drupal']['root'] }"
  command "drush vset --yes varnish_version #{ varnish_version }"
end
execute "configure-varnish-module-key" do
  cwd "#{ node['drupal']['root'] }"
  command "drush vset --yes varnish_control_key #{ varnish_control_key }"
end
execute "configure-varnish-module-terminal" do
  cwd "#{ node['drupal']['root'] }"
  command "drush vset --yes varnish_control_terminal #{ varnish_control_terminal }"
end
