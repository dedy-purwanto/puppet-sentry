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
  $web_port   = 9000,
  $workers    = 3,
  $extra_cfg  = undef,
  $load_initial_data = true,

) {

    include sentry::install

    $virtualenv_path = "$path/virtualenv"

    $hexdigest = sha1("$salt$password")

    file{"$path/sentry.conf.py":
        ensure  => file,
        content => template("sentry/sentry.conf.py.erb"),
        owner   => $owner,
        group   => $group,
        notify  => Exec['sentry_initiate'],
    }

    if $load_initial_data {
      file{"$path/initial_data.json":
        ensure  => file,
        content => template("sentry/initial_data.json.erb"),
        notify  => Exec['sentry_initiate'],
        owner   => $owner,
        group   => $group,
        before  => Exec['sentry_initiate'],
      }
    }

    exec{"sentry_initiate":
        command     => "bash -c 'source $virtualenv_path/bin/activate && sentry --config=$path/sentry.conf.py upgrade --noinput'",
        user        => $owner,
        group       => $group,
        refreshonly => true,
        logoutput   => on_failure,
        require     => Class["sentry::install"],
        notify  => Class['sentry::service'],
        timeout => 0, /* sentry syncdb and migration takes a long time, better make the timeout to be infinite */
    }
}
