class sentry::install($password, $salt="bf13c0"){
    $sentry_path = "/var/sentry"
    $virtualenv_path = "$sentry_path/virtualenv"

    $hexdigest = sha1("$salt$password")

    exec{"sentry_path":
        command => "/bin/mkdir -p $sentry_path",
        creates => $sentry_path
    }

    file{"$sentry_path/requirements.txt":
        ensure => file,
        require => Exec[$sentry_path],
        source => "puppet:///modules/sentry/requirements.txt"
    }

    file{"$sentry_path/settings.py":
        ensure => file,
        require => Exec[$sentry_path],
        content => template("sentry/settings.py.erb")
    }

    exec{"virtualenv":
        command => "virtualenv $virtualenv_path",
        creates => "$virtualenv_path/bin/activate",
        require => Exec[$sentry_path]
    }

    exec{"sentry_requirements":
        command => "bash -c 'source $virtualenv_path/bin/activate && pip --timeout=280 install -r $sentry_path/requirements.txt --download-cache=~/.pip/cache'",
        require => File["$sentry_path/requirements.txt"]
    }

    file{"$sentry_path/initial_data.json":
        ensure => file,
        require => Exec["sentry_requirements"],
        content => template("sentry/initial_data.json.erb")
    }

    exec{"sentry_initiate":
        command => "bash -c 'source $virtualenv_path/bin/activate && sentry --config=$sentry_path/settings.py upgrade --noinput'",
        require => File["$sentry_path/initial_data.json"],
        timeout => 0, /* sentry syncdb and migration takes a long time, better make the timeout to be infinite */
    }

    file{"$sentry_path/initial_data.json": /* for safety */
        ensure => absent,
        require => Exec["sentry_initiate"]
    }
        
}

class sentry($password, $salt="bf13c0"){
    class{'sentry::python':}
    class{'sentry::install':
        require => Class['sentry::python'],
        password => $password,
        salt => $salt,
    }

}
