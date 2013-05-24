# Sample vagrant config file

Create your destroyable environment with vagrant.

## Set up secret key for data bag

Create secret key.

```
$ knife solo init chef-solo
$ cd chef-solo
$ openssl rand -base64 512 > data_bag_key
```

Put key to common directory.

```
$ mv data_bag_key ~/.chef/data_bag_key
$ edit ~/.chef/knife.rb

    encrypted_data_bag_secret "#{ENV['HOME']}/.chef/data_bag_key"
```

## Usage

```
$ gem install vagrant
$ vagrant up
```

## www directory

Once vm up, www directory created in host directory. The www file is symlinked to `/var/www` in vm.
This is useful when crafting a web site. And .htaccess and php54 are available.
The site can be seen as http://192.168.33.10 in browser.

## vim

Adding to default vi, vim is installed. Default vim dotfiles are shipped with `neobundle` and `vimproc`.
So, please install bundles via following command when you launch vim for the first time.

```
:NeoBundleInstall
```
