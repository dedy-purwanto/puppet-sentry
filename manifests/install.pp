class sentry::install($method=undef){

    $sentry_path = "/var/sentry"

    $virtualenv_path = "$sentry_path/virtualenv"

    # user/group
    user { 'sentry':
        ensure => present,
        comment => 'Sentry user',
        gid => 'sentry',
        home => "$sentry_path",
        require => Group['sentry'],
    }

    group { 'sentry':
        ensure => present,
    }



    file { "$sentry_path":
        ensure => directory,
    }

    case $method {
        'venv', 'default': {
            class { "sentry::install::$method":
                sentry_path => $sentry_path,
                virtualenv_path => $virtualenv_path
            }
        }
        default: {
            fail('please specify an acceptable method out of venv, default')
        }
    }
}
