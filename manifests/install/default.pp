class sentry::install::default($entry_path, $virtualenv_path) {

    exec{"virtualenv":
        command => "virtualenv $virtualenv_path",
        creates => "$virtualenv_path/bin/activate",
        require => File[$sentry_path]
    }

    exec{"sentry_requirements":
        command => "bash -c 'source $virtualenv_path/bin/activate && pip --timeout=280 install -r $sentry_path/requirements.txt --download-cache=~/.pip/cache'",
        require => File["$sentry_path/requirements.txt"]
    }
}
