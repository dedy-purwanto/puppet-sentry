class sentry::install($password, $salt="bf13c0", $method=undef){
    $sentry_path = "/var/sentry"
    $virtualenv_path = "$sentry_path/virtualenv"

    $hexdigest = sha1("$salt$password")

    $sentry_url_prefix = 'http://sentry.example.com'
    $sentry_key = '0123456789abcde'
    $sentry_web_port = 9000

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

    file{"$sentry_path/sentry.conf.py":
        ensure => file,
        content => template("sentry/sentry.conf.py.erb")
    }

    file{"$sentry_path/initial_data.json":
        ensure => file,
        content => template("sentry/initial_data.json.erb")
    }

    exec{"sentry_initiate":
        command => "bash -c 'source $virtualenv_path/bin/activate && sentry --config=$sentry_path/settings.py upgrade --noinput'",
        require => [
            File["$sentry_path/initial_data.json"],
            Class["sentry::install::$method"]
        ],
        timeout => 0, /* sentry syncdb and migration takes a long time, better make the timeout to be infinite */
    }
}
