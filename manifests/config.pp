class sentry::config (
  $password,
  $salt       = 'bf13c0',
  $path       = '/var/sentry',
  $key        = '0123456789abcde',
  $email      = 'admin@example.com',
  $owner      = 'sentry',
  $group      = 'sentry',
  $url_prefix = undef,
  $sub_url    = undef,
  $web_port   = 9000
) {

    include sentry::install


    $virtualenv_path = "$path/virtualenv"

    $hexdigest = sha1("$salt$password")

    file{"$path/sentry.conf.py":
        ensure  => file,
        content => template("sentry/sentry.conf.py.erb"),
        owner   => $owner,
        group   => $group,
        notify  => Class['sentry::service'],
    }

    file{"$path/initial_data.json":
        ensure  => file,
        content => template("sentry/initial_data.json.erb"),
        owner   => $owner,
        group   => $group
    }

    exec{"sentry_initiate":
        command => "bash -c 'source $virtualenv_path/bin/activate && sentry --config=$path/sentry.conf.py upgrade --noinput'",
        user   => $owner,
        group  => $group,
        require => [
            File["$path/initial_data.json"],
            Class["sentry::install"]
        ],
        timeout => 0, /* sentry syncdb and migration takes a long time, better make the timeout to be infinite */
    }
}
