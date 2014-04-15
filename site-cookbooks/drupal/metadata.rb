name 'drupal'
maintainer 'Angry Cactus Technlogy'
maintainer_email 'contact@angrycactus.biz'
license 'GPLv2.0'
description 'Configure a LAMP serevr with optimal settings for Drupal.'
version '0.1.1'

# Dependencies.
<<<<<<< HEAD
depends_recipes = %w{ mysql apache2 php memcached git composer varnish database conf buildbot }
=======
depends_recipes = %w{ mysql apache2 php memcached git composer varnish database conf cron }
>>>>>>> upstream/master
# Currentry we sopport only Ubuntu.
supports_os = %w{ ubuntu }

depends_recipes.each do |recipe|
  depends recipe
end

supports_os.each do |os|
  supports os
end
