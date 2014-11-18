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
#       This should contain the protocol and hostname part; e.g.
#       https://myhost
# [*sub_url*]
#       The sub url sentry is accessible on on the given url_prefix.
#       Start with a slash, end without.
# [*web_port*]
#       The port the web server will listen on.
# [*workers*]
#       The number of gunicorn workers to start
# [*install_method*]
#       The installation method used to install sentry.
#       Choose from:
#
#       [venv]    Using python::venv from the module
#                 https://github.com/uggedal/puppet-module-python
#
#       [default] Using virtualenv directly, which will do sudo install
# [*extra_cfg*]
#       Extra configuration at the end of sentry.conf.py
# [*monitor*]
#       Whether to add monitoring of this service
# [*monitor_tool*]
#       Array of tools to monitor with; currently supports nagios.
# [*load_initial_data*]
#       Should initial_data.json be created (default: true).
#       You will have to disable this to install new version of sentry (6.X),
#       because it uses a custom model for User, and this need to be created
#       after migrations have run.
#
#       Caution: setting this to false will ignore the other options:
#                password, salt
# [*requirements_source*]
#       Use customer requirements.txt file. This option allows installing a
#       different version of sentry than 5.1.5, which is the default for this
#       module. To install the latest available version of sentry, just pass
#       a file with just one line "sentry" without specifying the version.
#
# === Requires
#
# [python::venv] for *install_method* 'venv'
# [supervisor]   from https://github.com/plathrop/puppet-module-supervisor
#
# === Sample Usage
#
#    class { 'sentry':
#      password       => 's3ntry',
#      path           => '/var/sentry',
#      install_method => 'venv'
#    }
#
class sentry (
  $password       = 'youshouldspecifyyourownpassword',
  $salt           = 'andyourownsalt',
  $path           = '/var/sentry',
  $key            = 'andyourownkey0123456789abcde',
  $email          = 'admin@example.com',
  $url_prefix     = undef,
  $sub_url        = undef,
  $web_port       = 9000,
  $workers        = 3,
  $install_method = undef,
  $extra_cfg      = undef,
  $monitor        = true,
  $monitor_tool   = ['nagios'],
  $load_initial_data = true,
  $requirements_source = "puppet:///modules/sentry/requirements.txt"
) {

  class { 'sentry::install':
    method => $install_method,
    path   => $path,
    requirements_source => $requirements_source,
  }

  class { 'sentry::config':
    password   => $password,
    salt       => $salt,
    path       => $path,
    key        => $key,
    email      => $email,
    url_prefix => $url_prefix,
    sub_url    => $sub_url,
    web_port   => $web_port,
    workers    => $workers,
    extra_cfg  => $extra_cfg,
    load_initial_data => $load_initial_data,
  }

  class { 'sentry::service':
    path       => $path
  }

  if (($monitor == true) and ($monitor_tool =~ /nagios/)) {
    class { 'sentry::nagios':
      web_port => $web_port
    }
  }

}
