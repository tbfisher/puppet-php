define php::ini_setting (
  $setting = $title,
  $value,
  $section = '',
  $sapi='ALL' # ALL|apache2|cli|fpm
  )
{

  if ! defined(Class['php']) {
    fail('You must include the php base class before using any php defined resources')
  }

  if $section == '' {
    $ini_title = "${setting}"
  }
  else {
    $ini_title = "${section} ${setting}"
  }
  if ($sapi == 'ALL' and member($php::sapi, 'cli')) or $sapi == 'cli' {
    ini_setting { "php cli ${ini_title}":
      ensure => present,
      path => "/etc/php5/cli/php.ini",
      section => $section,
      setting => $setting,
      value => $value,
      require => Class['php'],
    }
  }
  if ($sapi == 'ALL' and member($php::sapi, 'apache2')) or $sapi == 'apache2' {
    ini_setting { "php apache2 ${ini_title}":
      ensure => present,
      path => "/etc/php5/apache2/php.ini",
      section => $section,
      setting => $setting,
      value => $value,
      require => Class['php'],
      notify => Service['apache2'],
    }
  }
  if ($sapi == 'ALL' and member($php::sapi, 'fpm')) or $sapi == 'fpm' {
    ini_setting { "php fpm ${ini_title}":
      ensure => present,
      path => "/etc/php5/fpm/php.ini",
      section => $section,
      setting => $setting,
      value => $value,
      require => Class['php'],
      notify => Service['php5-fpm'],
    }
  }
}
