name "spec-low"
description "Role for nodes with low specifications."
#http://wiki.vpslink.com/Low_memory_MySQL_/_Apache_configurations
override_attributes(
  :mysql => { 
    :tunable => {
      :max_allowed_packet => "1M",
      :table_cache => "4",
      :sort_buffer_size => '16K',
      :read_buffer_size => '256K',
      :read_rnd_buffer_size => '256K',
      :thread_stack => "64k",
      # 20% of the memory, calculated for 512M RAM
      :key_buffer_size => "102M",
      # InnoDB
      :innodb_buffer_pool_size => '16M',
      :innodb_additional_mem_pool_size => '2M',
    } 
  },
  :apache => {
    :prefork => {
      :startservers => "1",
      :minspareservers => "1",
      :maxspareservers => "5",
      :serverlimit => "50",
      :maxclients => "50",
      :maxrequestsperchild => "5000"
    }
  }
  # Defaults are good enough for memcached.
  # PHP dont have attributes for resources tweaks.
)
