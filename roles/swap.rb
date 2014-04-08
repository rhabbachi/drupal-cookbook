name 'swap'
description "Role for nodes with swapfile."
override_attributes "create-swap" => { "swap-size" => 2 }
run_list "recipe[swap]"
