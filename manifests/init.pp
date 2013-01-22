# == Class: sentry
#
# This class installs/configures/manages Sentry.
#
# === Parameters
#
# [*password*]
#       The password to use for Sentry's admin user.
# [*salt*]
#       The salt to use for the SHA-1 hexdigest of the password.
# [*key*]
#       The SENTRY_KEY to use.  Should be unique randomly generated for your
#       server.  Use 'sentry init' to generate a config with a random key
#       to cut and paste.
# [*email*]
#       The administrator's email address
# [*url_prefix*]
#       The url prefix sentry is accessible on.  If undefined, it is guessed,
#       but when using a proxy you probably want to set this.
# [*web_port*]
#       The port the web server will listen on.
# [*install_method*]
#       The installation method used to install sentry.
#       Choose from:
#           - venv:    Using python::venv from the module
#                      git://github.com/uggedal/puppet-module-python.git
#           - default: Using virtualenv directly, which will do sudo install
#
# === Requires:
#   python::venv for install_method 'venv'
#
# === Sample Usage:
#    class { 'sentry':
#      password       => 's3ntry',
#      path           => '/var/sentry',
#      install_method => 'venv'
#   }
# 
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

  class { 'sentry::service':
    path       => $path
  }
}
