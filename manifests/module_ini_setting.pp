define php::module_ini_setting (
  $setting = $title,
  $value,
  $package,
  )
{

  require php

  if defined(Package['php5-cli']) {
    $require_php = [Package['php5-cli']]
  }
  else {
    $require_php = []
  }

  if defined(Class['php::apache']) {
    $require_apache = [Package['libapache2-mod-php5']]
    $notify_apache = [Service['apache2']]
  }
  else {
    $require_apache = []
    $notify_apache = []
  }

  if defined(Class['php::nginx']) {
    $require_nginx = [Package['php5-fpm']]
    $notify_nginx = [Service['php5-fpm']]
  }
  else {
    $require_nginx = []
    $notify_nginx = []
  }

  ini_setting { "php ${package} ${setting}":
    ensure => present,
    path => "${php::php_mod_dir}/${package}.ini",
    section => '',
    setting => $setting,
    value => $value,
    require => concat(concat($require_php, $require_nginx), $require_apache),
    notify => concat($notify_nginx, $notify_apache),
  }

}
