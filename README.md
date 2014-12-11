# Puppet Module: PHP

A simple module for installing PHP on ubuntu trusty and precise.

## Usage

    class { '::php':
      sapi => ['cli', 'fpm'],
    } ->
    service { 'php5-fpm':
      enable => true,
      ensure => running,
    }
    ::php::ini_setting { 'error_log':
      section => 'PHP',
      value => '/var/log/php/error_log',
    }
    ::php::module { 'xdebug': } ->
    ::php::module_ini_setting { "xdebug.remote_enable":
      package => 'xdebug',
      value => 1,
    }
