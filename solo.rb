file_cache_path           "/tmp/chef-solo"
data_bag_path             "./data_bags"
encrypted_data_bag_secret "#{ENV['HOME']}/.chef/data_bag_key"
cookbook_path             [ "./site-cookbooks",
                            "./cookbooks" ]
role_path                 "./chef-solo/roles"
