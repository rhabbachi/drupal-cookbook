name "base"
description "Role for base node setup."
run_list "recipe[vim]", "recipe[git]"
