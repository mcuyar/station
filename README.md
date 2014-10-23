# What is Station?

Station is a simple, module based framework for customizing the [laravel/homestead](https://github.com/laravel/homestead) vagrant environment.

Station extends homesteads Yaml configuration file with features such as: xdebug, zsh, oh-my-zsh, ruby-gem installers and much more.

## Installation

1. Install requirements (Vagrant & Virtualbox)
	* Newest version of virtualbox [download](https://www.virtualbox.org/wiki/Downloads)
	* Virtualbox Extension Pack: located on virtualbox downloads page
	* Newest Vagrant build: Manages the virtual machine through virtual box [download](https://www.vagrantup.com/downloads.html)

2. Add the Laravel Homestead box to your vagrant environment:
	* `vagrant box add laravel/homestead`

## About Homestead

From the [Laravel Homestead](http://laravel.com/docs/4.2/homestead) page:

**Laravel Homestead is an official, pre-packaged Vagrant "box" that provides you a wonderful development environment without requiring you to install PHP, HHVM, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!**

## Getting Started

The best place to get started is to read the [wiki](https://github.com/mcuyar/station/wiki).