include_recipe "apt"

apt_repository "php54" do
  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E5267A6C"
end

apt_package "php5" do
  action :install
end

apt_package "php5-gd" do
  action :install
end

apt_package "php5-mysql" do
  action :install
end
