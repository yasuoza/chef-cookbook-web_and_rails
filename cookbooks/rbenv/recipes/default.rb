user_name = node['user']['name']
home      = node['user']['home']
ruby_version = node['rbenv']['version']

bash 'rbenv' do
  destination_path = "#{home}/.rbenv"
  repository = 'https://github.com/sstephenson/rbenv.git'
  destination = destination_path
  user user_name
  group user_name
  environment('HOME' => home)
  code <<-EOC
    git clone #{repository} #{destination_path}
  EOC
  not_if { ::File.exists?(destination_path) }
end

directory "#{home}/.rbenv/plugins" do
  owner user_name
  group user_name
  action :create
  not_if { File.exists?("#{home}/.rbenv/plugins") }
end

bash 'rbenv-gem-rehash' do
  destination_path = "#{home}/.rbenv/plugins/rbenv-gem-rehash"
  repository = 'https://github.com/sstephenson/rbenv-gem-rehash.git'
  destination = destination_path
  user user_name
  group user_name
  environment('HOME' => home)
  code <<-EOC
    git clone #{repository} #{destination_path}
  EOC
  not_if { File.exists?(destination_path) }
end

bash 'add rbenv to $PATH' do
  user user_name
  zshrc = "#{home}/.zshrc"
  code <<-EOC
    echo 'eval "$(rbenv init -)"' >> #{home}/.zshrc
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> #{zshrc}
  EOC
  not_if { File.open(zshrc).read.scan('export PATH="$HOME/.rbenv/bin:$PATH"').any? }
end

bash "git clone ruby-build" do
  user 'root'
  group 'root'
  destination_path = "#{Chef::Config[:file_cache_path]}/ruby-build"
  repository = "git://github.com/sstephenson/ruby-build.git"
  destination = destination_path
  code <<-EOC
    git clone #{repository} #{destination_path}
  EOC
  not_if { ::File.exists?("/usr/local/bin/ruby-build") }
end

bash "install_ruby_build" do
  cwd "#{Chef::Config[:file_cache_path]}/ruby-build"
  code <<-EOH
     ./install.sh
  EOH
  environment 'PREFIX' => "/usr/local"
  not_if { ::File.exists?("/usr/local/bin/ruby-build") }
end

bash "install ruby" do
  environment('HOME' => home)
  cwd home
  user user_name
  group user_name

  code <<-EOC
    source #{home}/.zshrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    MAKE_OPTS="-j 4" rbenv install #{ruby_version}
    rbenv global #{ruby_version}
  EOC
  not_if { ::File.exists?(home + "/.rbenv/versions/#{ruby_version}") }
end

node['rbenv']['gems'].each do |gem|
  bash "isntall default #{gem}" do
    environment('HOME' => home)
    cwd home
    user user_name
    group user_name

    code <<-EOC
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
      gem install #{gem}
      rbenv rehash
    EOC
    not_if { ::File.exists?(home + "/.rbenv/versions/#{ruby_version}/bin/#{gem}") }
  end
end
