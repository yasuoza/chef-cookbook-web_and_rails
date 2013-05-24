# chef-solo for web and rails development

Set up web and rails development environment.

## Requirements

* Ubuntu(~> 12.0.4)
* Chef(~> 11.4.0)

## Components

* git
* mysql
* sqlite3
* redis
* php54
* apache
* ruby-build
* rbenv
    * ruby(= 2.0.0-p195)
        * bundler
        * pry
* nodebrew
    * node(= stable)
        * coffee-script

## Developer user

name: developer  
password: password

Login:

```shell
$ ssh developer@your_host.com
```

## MySQL root user

password: root

## www directory

Once vm up, www directory created in host directory. The www file is symlinked to `/var/www` in vm.  
This is useful when crafting a web site. And .htaccess and php54 are available.
The site can be seen like http://192.168.33.10 in browser.

## Vagrant

If you want use this cookbook with vagrant, see `vagrant_example` directory.
