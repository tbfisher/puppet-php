# Puppet Module: PHP

A simple module for installing PHP on ubuntu trusty and precise.

## Install and Configure PHP

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

## Functions

### `to_php`

Takes a hash, array, or scaler and outputs its literal expression in php.

    <% @drupal_settings.each do |key, val| -%>
    $settings['<%= key %>'] = <%= scope.function_to_php([val]) %>;
    <% end -%>
