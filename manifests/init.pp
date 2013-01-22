class sentry (
  $password,
  $salt           = 'bf13c0',
  $path           = '/var/sentry',
  $install_method = undef
) {

  class { 'sentry::install':
    method => $install_method,
    path   => $path
  }

  class { 'sentry::config':
    password => $password,
    salt     => $salt,
    path     => $path
  }

}
