bash 'create www/html symlink' do
  code <<-EOC
    cp -r /var/www /vagrant/
    rm -rf /var/www
    ln -s /vagrant/www /var/www
  EOC
  not_if { File.exists?('/vagrant/www') }
end
