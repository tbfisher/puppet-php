class php (
  $sapi = ['cli', 'apache2'],
) {

  if $operatingsystem == 'Ubuntu' and $lsbdistcodename == 'trusty' {
    $php_enmod = true
    $php_mod_dir = '/etc/php5/mods-available'
    # php -i | grep -E '^extension_dir' | awk '{print $(NF)}'
    $php_ext_dir = '/usr/lib/php5/20121212'
    $php_opcache = 'opcache'
  }
  elsif $operatingsystem == 'Ubuntu' and $lsbdistcodename == 'precise' {
    $php_enmod = false
    $php_mod_dir = '/etc/php5/conf.d'
    # php -i | grep -E '^extension_dir' | awk '{print $(NF)}'
    $php_ext_dir = '/usr/lib/php5/20090626'
    $php_mod_dir = 'apc'
  }
  else {
    notice("Unexpected OS ${operatingsystem} ${lsbdistcodename}")
  }

  package { [
      'php5',
      'php5-common',
      'php5-dev',
    ] :
  }

  if member($sapi, 'cli') {
    package { 'php5-cli': }
  }
  if member($sapi, 'apache2') {
    package { 'libapache2-mod-php5': }
  }
  if member($sapi, 'fpm') {
    package { 'php5-fpm': }
  }

}