drupal-cookbook
===============

This is a Drupal chef cookbook designed to work with
[Druploy](https://github.com/willieseabrook/druploy)

There are a number of Drupal cookbooks already available, but they tend not to
work very well with standard Drupal agency workflow.

This Drupal Chef Cookbook doesn't do anything with regards to installing Drupal
(as it assumes a normal agency workflow of everything coming out of custom git
repos)

All it does is configure a LAMP server with optimal settings for Drupal

# Requirements #

1. An Ubuntu 13.04 image. Does not work on 13.10 because of apache 2.4

# Installation #

## Vagrant ##

A Vagrantfile is provided to help with getting started with this cookbook and
help test different nodes run_lists. It's configured with berkshelf in mind and
require some vagrant plugins to work.

1. [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf): To be
   able to use berkshelf with vagrant.

```bash
vagrant plugin install vagrant-berkshelf
```

2.  [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus): Some
    cookbooks that drupal-cookbook depends on require the latest version of the
    chef-client in the vagrant vm.

```bash
vagrant plugin install vagrant-omnibus
```

## Chef ##

1. We provide a Gemfile with the dependency needed for running chef and chef solo.

```bash
bundle install via Gemfile.
```
# Usage #

## Vagrant ##

The Vagrantfile containt the chef configuration needed to run the cookbook on the virtual machine.

```bash
vagrant up
```

The chef client is configured to output the debug level log.

To inspect the resulting configuration you can login via ssh:

```bash
vagrant ssh
```

Tweaking the vagrant node is done by editing the chef configuration in the Vagrantfile:

```ruby
config.vm.provision :chef_solo do |chef|
# Chef configuration
end
```

## Chef ##

To use this cookbook with real nodes, you can use the example configuration files provided:

1. Copy and edit the example user in the data_bag/users folder. It's higly
   recommanded to add your public ssh key to the user configurations for
   passwordless ssh logins.

   ```bash
   cp data_bags/users/example.json data_bags/users/admin.json
   ```

```json
{
    ...
    /* Add your public keys */
    "ssh_keys"  : [""]
}
```
2. A node with the cookbook setup is also available, copy it with the targeted domaine.

```bash
cp nodes/example.json nodes/yourserver.com
```

3. Prepare the node for chef.

```bash
knife solo prepare root@yourserver.com
```

4. Now you can run the cookbook on the node.

```bash
knife solo cook root@yourserver.com
```

