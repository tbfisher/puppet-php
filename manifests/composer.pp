define php::composer (
  $install_dir = $name,
  $user = 'root',
  $bin = 'composer.phar',
){

  if $user == 'root' {
    $home = '/root'
  }
  else {
    $home = "/home/${user}"
  }

  if ($bin != 'composer.phar') {
    exec { "Install ${install_dir}/${bin}":
      command => "curl -sS https://getcomposer.org/installer | php && mv /tmp/composer.phar ${install_dir}/${bin}",
      cwd => '/tmp',
      environment => "COMPOSER_HOME=${home}",
      creates => "${install_dir}/${bin}",
    }
  }
  else {
    exec { "Install ${install_dir}/composer.phar":
      command => "curl -sS https://getcomposer.org/installer | php -- --install-dir=${install_dir}",
      environment => "COMPOSER_HOME=${home}",
      creates => "${install_dir}/composer.phar",
    }
  }

}
