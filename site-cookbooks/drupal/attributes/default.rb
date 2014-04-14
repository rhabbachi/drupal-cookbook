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
#Buildbot
default['buildbot']['user'] = 'buildbot'
default['buildbot']['group'] = 'buildbot'

default['buildbot']['project']['title'] = 'Pyflakes'
default['buildbot']['project']['title_url'] = 'http://divmod.org/trac/wiki/DivmodPyflakes'

default['buildbot']['master']['host'] = 'localhost'
default['buildbot']['master']['deploy_to'] = '/opt/buildbot'
default['buildbot']['master']['basedir'] = 'master'
default['buildbot']['master']['options'] = ''
default['buildbot']['master']['cfg'] = 'master.cfg'
default['buildbot']['master']['databases'] = [ 'sqlite:///state.sqlite' ]

default['buildbot']['slave']['port'] = '9989'
default['buildbot']['slave']['deploy_to'] = '/var/www'
default['buildbot']['slave']['options'] = ''
default['buildbot']['slave']['name'] = 'example-slave'
default['buildbot']['slave']['password'] = 'pass'
default['buildbot']['slave']['basedir'] = 'myproject'
default['buildbot']['slave']['admin'] = 'Your Name Here <admin@youraddress.invalid>'
default['buildbot']['slave']['host_info'] = ''
default['buildbot']['slave']['packages'] = [ 'make' ]

# Info for the master. This is for the case when it is deployed with chef-solo
# One Master and one Slave.
# For Chef Server it should be discovered by searching
default['buildbot']['slaves'] = [{
  'name'     => node['buildbot']['slave']['name'],
  'password' => node['buildbot']['slave']['password']
}]

# Change Source
default['buildbot']['imports']['change_source'] = [
  'from buildbot.changes.gitpoller import GitPoller'
]
default['buildbot']['change_source'] = "GitPoller(
    repourl='git://github.com/buildbot/pyflakes.git',
    workdir='gitpoller-workdir', branch='master',
    pollinterval=300)"

# Builders
default['buildbot']['imports']['factory'] = [
  'from buildbot.process.factory import BuildFactory',
  'from buildbot.config import BuilderConfig'
]
default['buildbot']['builders'] = [
  "BuilderConfig(name='runtests',
    slavenames=[#{node['buildbot']['slaves'].map {|s| "'#{s['name']}'" }.join(',')}],
    factory=factory)"
]

# Steps
default['buildbot']['imports']['steps'] = [
  'from buildbot.steps.source import Git',
  'from buildbot.steps.shell import ShellCommand',
]
default['buildbot']['steps'] = [
  "Git(repourl='git://github.com/buildbot/pyflakes.git', mode='copy')",
  "ShellCommand(command=['bash', '-c', 'fab build -f ../scripts/fabfile.py'], workdir='build/drupal')"
]

# Schedulers
default['buildbot']['imports']['schedulers'] = [
  'from buildbot.schedulers.basic import SingleBranchScheduler',
  'from buildbot.schedulers.forcesched import ForceScheduler',
  'from buildbot.changes import filter'
]
default['buildbot']['schedulers'] = [
  "SingleBranchScheduler(
    name='all',
    change_filter=filter.ChangeFilter(branch='master'),
    treeStableTimer=None,
    builderNames=['runtests'])",
  "ForceScheduler(
    name='force',
    builderNames=['runtests'])"
]

# Status
default['buildbot']['imports']['status'] = [
'from buildbot.status import html',
'from buildbot.status.web import authz, auth'
]
default['buildbot']['status_authz'] = "authz.Authz(
        auth=auth.BasicAuth([('pyflakes','pyflakes')]),
        gracefulShutdown=False,
        forceBuild='auth',
        forceAllBuilds=False,
        pingBuilder=False,
        stopBuild=False,
        stopAllBuilds=False,
        cancelPendingBuild=False)
"
default['buildbot']['status'] = [
  "html.WebStatus(http_port=8010,
    authz=#{node['buildbot']['status_authz']})"
]
