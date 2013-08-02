user      = node['user']
user_name = user['name']
password  = Chef::EncryptedDataBagItem.load("passwords", user_name)['password']
ssh_key   = user['ssh_key']
home      = "/home/#{user_name}"

gem_package "ruby-shadow" do
  action :install
end

user user_name do
  password password
  home  home
  shell "/bin/zsh"
  supports :manage_home => true
  action :create
end

bash 'add user to sudoers' do
  code <<-EOC
      sudo adduser #{user_name} sudo
  EOC
  only_if { user['sudoer'] }
end

directory "#{home}/.ssh" do
  owner user_name
  group user_name
  action :create
end

authorized_keys_file ="#{home}/.ssh/authorized_keys"
file authorized_keys_file do
  owner user_name
  mode  0600
  action :create
  not_if { File.exists?(authorized_keys_file) }
end

bash 'clone dotfiles' do
  destination_path = "#{home}/dotfiles"
  repository = 'https://github.com/yasuoza/dotfiles.git'
  destination = destination_path
  user user_name
  group user_name
  environment('HOME' => home)
  code <<-EOC
    git clone #{repository} #{destination_path}
  EOC
  not_if { File.exists?(destination_path) }
end

bash 'link_dotfiles' do
  user user_name
  group user_name
  environment('HOME' => home)
  cwd "#{home}/dotfiles"
  code <<-EOC
    ./setup.sh
  EOC
  not_if { File.exists?("#{home}/.zshrc.alias") }
end

bash 'prepare vim' do
  user user_name
  group user_name
  environment('HOME' => home)
  cwd "#{home}/dotfiles"
  code <<-EOC
    cp -r .vim ~/ && cd ~/.vim
    mkdir bundle && cd bundle
    git clone https://github.com/Shougo/neobundle.vim.git
    git clone https://github.com/Shougo/vimproc.git
    cd vimproc
    make -f make_unix.mak
  EOC
  not_if { File.exists?("#{home}/.vim") }
end

template "#{home}/.gitconfig.local" do
  owner user_name
  group user_name
  variables(
    :user_name => user_name,
    :user_email => user['email'] || user_name + "@example.com"
  )
  not_if { File.exists?("#{home}/.gitconfig.local") }
end
