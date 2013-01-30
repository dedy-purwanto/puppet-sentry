class sentry::install (
  $method = undef,
  $path   = '/var/sentry'
) {
    $virtualenv_path = "${path}/virtualenv"

    # user/group
    user { 'sentry':
        ensure  => present,
        comment => 'Sentry user',
        gid     => 'sentry',
        home    => $path,
        require => Group['sentry'],
    }

    group { 'sentry':
        ensure => present,
    }

    file { $path:
        ensure => directory,
    }

    case $method {
        'venv', 'default': {
            class { "sentry::install::${method}":
                sentry_path     => $path,
                virtualenv_path => $virtualenv_path
            }
        }
        default: {
            fail('please specify an acceptable method out of venv, default')
        }
    }
}
