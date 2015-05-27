define php::module (
  $module = $title,
  $package = "php5-${title}",
  $sapi = 'all',
) {

  require php

  package { $package: }

  # Packages are not necessarily enabled by default.
  if $php::php_enmod {
    if ($sapi == 'ALL' and member($php::sapi, 'cli')) or $sapi == 'cli' {
      exec { "php5enmod -s cli ${module}":
        creates => "/etc/php5/cli/conf.d/20-${module}.ini",
        require => Package[$package],
      }
    }
    if ($sapi == 'ALL' and member($php::sapi, 'apache2')) or $sapi == 'apache2' {
      exec { "php5enmod -s apache2 ${module}":
        creates => "/etc/php5/apache2/conf.d/20-${module}.ini",
        require => Package[$package],
        notify => Service['apache2'],
      }
    }
    if ($sapi == 'ALL' and member($php::sapi, 'fpm')) or $sapi == 'fpm' {
      exec { "php5enmod -s fpm ${module}":
        creates => "/etc/php5/fpm/conf.d/20-${module}.ini",
        require => Package[$package],
        notify => Service['php5-fpm'],
      }
    }
  }
}
