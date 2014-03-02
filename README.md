drupal-cookbook
===============

This is a Drupal chef cookbook designed to work with [Druploy](https://github.com/willieseabrook/druploy)

There are a number of Drupal cookbooks already available, but they tend not to work very well with standard Drupal agency workflow.

This Drupal Chef Cookbook doesn't do anything with regards to installing Drupal (as it assumes a normal agency workflow of everything coming out of custom git repos)

All it does is configure a LAMP server with optimal settings for Drupal

# Requirements #

1. An Ubuntu 13.04 image. Does not work on 13.10 because of apache 2.4

# Installation #

1. Chef, knife, knife solo

# Usage #

1. cp data_bags/users/example.json data_bags/users/admin.json
1.1 Generate and paste ssh key text into the admin.json file
2. cp nodes/example.json nodes/yourserver.com
3. knife solo prepare root@yourserver.com
3. knife solo cook root@yourserver.com

