include_recipe 'apt'

apt_package "python-software-properties" do
  action :install
end

apt_package "apt-transport-https" do
  action :install
end

apt_repository "git-core" do
  uri "http://ppa.launchpad.net/git-core/ppa/ubuntu"
  distribution "precise"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E1DF1F24"
end

apt_package "git" do
  action :install
end
