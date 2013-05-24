package "tcl"

bin = "/usr/local/bin/redis-server"
version  = node[:redis][:version]
file = "redis-#{version}"
url = "https://redis.googlecode.com/files/redis-#{version}.tar.gz"
installed_version = `#{bin} -v 2>&1`.chomp.split(/\s/)[2].sub("v=","")
log "installed version: #{installed_version}"
do_install = ( version != installed_version )


remote_file "/tmp/redis-#{version}.tar.gz" do
  source "#{url}"
  mode "0644"
  only_if { do_install }
end

bash "install_redis" do
  cwd "/tmp"
  code <<-EOH
    tar zxvf #{file}.tar.gz
    cd #{file}
    make && make install
  EOH
  only_if { do_install }
end

template "/tmp/#{file}/utils/install_server.sh" do
  owner "root"
  group "root"
  only_if { do_install }
end

bash "install redis using install_server.sh" do
  cwd "/tmp/#{file}"
  code <<-EOC
    cd utils
    ./install_server.sh
  EOC
  only_if { do_install }
end

file "/tmp/#{file}.tar.gz" do
  action :delete
end

