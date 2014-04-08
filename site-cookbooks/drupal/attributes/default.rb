# Dependencies overrides
override['apache']['default_site_enabled'] = false
override['mysql']['bind_address'] = '127.0.0.1'
# Drupal
default['drupal'][ 'root' ] = '/var/www/drupal'
default['drupal'][ 'sites' ] = ['default']
override['drupal'][ 'http' ][ 'ports' ] = [ '8080' ]
default['drupal'][ 'user' ] = 'chef'
# Drush
default['drupal'][ 'drush' ]['install_dir'] = "/usr/share/php/drush"
default['drupal'][ 'drush' ][ 'version' ] = "master"
# Varnish
override['drupal'][ 'varnish' ][ 'port' ] = 80
default['varnish']['vcl_cookbook'] = 'drupal'
default['varnish']['vcl_source'] = 'drupal.vcl.erb'
default['varnish']['vcl_conf'] = 'drupal.vcl'
# Restore
default['drupal']['restore']['path_source'] = ''
default['drupal']['restore']['db_su'] = 'chef'
default['drupal']['restore']['db_su_pw'] = 'chef'
default['drupal']['restore']['overwrite'] = 'true'
# Backup
default['drupal']['backup']['minute'] = '0'
default['drupal']['backup']['daily'] = '0'
default['drupal']['backup']['hourly'] = '0'
default['drupal']['backup']['monthly'] = '0'
default['drupal']['backup']['weekday'] = '0'
default['drupal']['backup']['sites'] = ['default']
default['drupal']['backup']['destination'] = '/dev/null'
default['drupal']['backup']['mails'] = ['example@localhost.lan']
default['drupal']['backup']['exclude'] = ['.git']
default['drupal']['backup']['generator'] = 'Chef Drupal Cookbook'
