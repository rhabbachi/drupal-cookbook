name 'admin-user'
description 'Role for creating the box admin, by default called drupal and has a passwordless sudo'
run_list "recipe[user::data_bag]", "recipe[sudo]"
default_attributes(
  :users => ["drupal"],
  :authorization => {
    :sudo => {
      :users => ["drupal"],
      :passwordless => "true"
    }
  }
)
