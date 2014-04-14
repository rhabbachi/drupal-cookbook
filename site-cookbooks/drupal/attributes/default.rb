# Dependencies overrides
override['apache']['default_site_enabled'] = false
override['mysql']['bind_address'] = '127.0.0.1'
# Drupal
# Project
default['drupal']['druploy_enabled'] = false
default['drupal']['name'] = 'drupal'
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
default['drupal']['backup']['source'] = '/var/backups'
## Cron
default['drupal']['backup']['minute'] = '*/3'
default['drupal']['backup']['hourly'] = '*'
default['drupal']['backup']['daily'] = '*'
default['drupal']['backup']['monthly'] = '*'
default['drupal']['backup']['weekday'] = '*'
## GPG
default['drupal']['backup']['gpg_keys'] = ['disabled']
default['drupal']['backup']['gpg_pw'] = nil
## S3 data_bag name
default['drupal']['backup']['target_s3'] = 'test'
## Duplicity
# Time frame for old backups to keep, Used for the "purge" command.  
# see duplicity man page, chapter TIME_FORMATS)
#MAX_AGE=1M
default['drupal']['backup']['max_age'] = nil
default['drupal']['backup']['max_full_backups'] = nil
default['drupal']['backup']['max_fullbkp_age'] = nil
default['drupal']['backup']['volsize'] = nil

default['drupal']['backup']['mails'] = ['example@localhost.lan']
default['drupal']['backup']['exclude'] = ['.git']
default['drupal']['backup']['generator'] = 'Chef Drupal Cookbook'
