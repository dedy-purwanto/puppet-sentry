class sentry::install::venv ($sentry_path, $virtualenv_path) {

    class { 'python::venv':
      owner => 'sentry',
      group => 'sentry'
    }

    python::venv::isolate { "$virtualenv_path":
        requirements => "$sentry_path/requirements.txt",
        requirements_source => "puppet:///modules/sentry/requirements.txt"
    }
}
