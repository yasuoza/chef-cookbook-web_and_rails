# Sample vagrant config file

Create your destroyable environment with vagrant.

## Set up base vagrant box

This example is baed on ubuntu precise 64.
If you didn't add it to your box list, add it first.

```
$ vagrant box add precise64 http://files.vagrantup.com/precise64.box
```

## Usage

Start vm:

```
$ vagrant up
```

Shut down:

```
$ vagrant halt
```

Restart vm:

```
$ vagrant reload
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
