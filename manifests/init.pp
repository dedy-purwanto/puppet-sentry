class sentry (
  $password,
  $salt           = 'bf13c0',
  $path           = '/var/sentry',
  $key            = '0123456789abcde',
  $email          = 'admin@example.com',
  $url_prefix     = undef,
  $web_port       = 9000,
  $install_method = undef
) {

  class { 'sentry::install':
    method => $install_method,
    path   => $path
  }

  class { 'sentry::config':
    password   => $password,
    salt       => $salt,
    path       => $path,
    key        => $key,
    email      => $email,
    url_prefix => $url_prefix,
    web_port   => $web_port,
  }

}
