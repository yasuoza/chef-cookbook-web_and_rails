user_name = node['user']['name']
home = "/home/#{user_name}"
node_version = node['node']['version']

bash 'install nodebrew' do
  user user_name
  group user_name
  environment('HOME' => home)
  cwd home
  code <<-EOC
    curl -L git.io/nodebrew | perl - setup
    echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> .zshrc
    export PATH=$HOME/.nodebrew/current/bin:$PATH
    nodebrew install-binary #{node_version}
    nodebrew use #{node_version}
  EOC
  not_if { File.exists?(home + '/.nodebrew/current') }
end

node['node']['npms'].each do |npm|
  bash 'install default npms' do
    user user_name
    group user_name
    environment('HOME' => home)
    cwd home
    npm_path = home + '/.nodebrew/current/bin'
    code <<-EOC
      export PATH=$HOME/.nodebrew/current/bin:$PATH
      npm install -g #{npm}
    EOC
    not_if { File.exists?(npm_path + "/#{npm}") }
  end
end
