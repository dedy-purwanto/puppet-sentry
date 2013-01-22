class sentry::config (
  $password,
  $salt       = 'bf13c0',
  $path       = '/var/sentry',
  $key        = '0123456789abcde',
  $email      = 'admin@example.com',
  $url_prefix = undef,
  $web_port   = 9000
) {

    include sentry::install


    $virtualenv_path = "$path/virtualenv"

    $hexdigest = sha1("$salt$password")

    file{"$path/sentry.conf.py":
        ensure => file,
        content => template("sentry/sentry.conf.py.erb")
    }

    file{"$path/initial_data.json":
        ensure => file,
        content => template("sentry/initial_data.json.erb")
    }

    exec{"sentry_initiate":
        command => "bash -c 'source $virtualenv_path/bin/activate && sentry --config=$path/settings.py upgrade --noinput'",
        require => [
            File["$path/initial_data.json"],
            Class["sentry::install"]
        ],
        timeout => 0, /* sentry syncdb and migration takes a long time, better make the timeout to be infinite */
    }
}
