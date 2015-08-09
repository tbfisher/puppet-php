# php ppa if needed
class php::ppa (
  $version = undef,
) {
  # https://launchpad.net/~ondrej
  case $version {
    '5.4': {
      ::apt::ppa { 'ppa:ondrej/php5-oldstable': }
    }
    '5.5': {
      ::apt::ppa { 'ppa:ondrej/php5': }
    }
    '5.6': {
      ::apt::ppa { 'ppa:ondrej/php5-5.6': }
    }
    default: {}
  }
}

# simple class for installing php, on ubuntu
class php (
  $sapi = ['cli', 'apache2'],
  $version = undef,
) {

  class { '::php::ppa': version => $version }
  contain '::php::ppa'

  $php_enmod   = true
  $php_mod_dir = '/etc/php5/mods-available'

  if $::operatingsystem == 'Ubuntu' and $::lsbdistcodename == 'trusty' {
    # php -i | grep -E '^extension_dir' | awk '{print $(NF)}'
    $php_opcache = 'opcache'
    case $version {
      # https://launchpad.net/~ondrej
      '5.4':   {
        fail('PHP 5.4 can not be installed on trusty')
      }
      '5.5':   {
        $php_ext_dir = '/usr/lib/php5/20121212'
      }
      '5.6':   {
        $php_ext_dir = '/usr/lib/php5/20131226'
      }
      default: {
        $php_ext_dir = '/usr/lib/php5/20121212'
      }
    }
  }
  elsif $::operatingsystem == 'Ubuntu' and $::lsbdistcodename == 'precise' {
    # php -i | grep -E '^extension_dir' | awk '{print $(NF)}'
    $php_opcache = 'apc'
    case $version {
      # https://launchpad.net/~ondrej
      '5.4':   {
        $php_ext_dir = '/usr/lib/php5/20100525'
      }
      '5.5':   {
        $php_ext_dir = '/usr/lib/php5/20121212'
      }
      '5.6':   {
        $php_ext_dir = '/usr/lib/php5/20131226'
      }
      default: {
        $php_ext_dir = '/usr/lib/php5/20100525'
      }
    }
  }
  else {
    fail("Unexpected OS ${::operatingsystem} ${::lsbdistcodename}")
  }

  package { [
      'php5',
      'php5-common',
      'php5-dev',
    ] :
    require => Class['::php::ppa'],
  }

  if member($sapi, 'apache2') {
    if member($sapi, 'cli') {
      package { 'php5-cli':
        require => Class['::php::ppa'],
      }
    }
    package { 'libapache2-mod-php5':
      require => Class['::php::ppa'],
    }
  }
  if member($sapi, 'fpm') {
    if member($sapi, 'cli') {
      package { 'php5-cli':
        require => [
          Class['::php::ppa'],
          Package['php5-fpm'],
        ],
      }
    }
    package { 'php5-fpm':
      require => Class['::php::ppa'],
      before  => [
        Package['php5'],
        Package['php5-common'],
        Package['php5-dev'],
      ],
    }
  }

}