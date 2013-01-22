class sentry::install::venv ($sentry_path, $virtualenv_path) {

    include python::venv

    python::venv::isolate { "$virtualenv_path":
        requirements => "$sentry_path/requirements.txt",
        requirements_source => "puppet:///modules/sentry/requirements.txt"
    }
}
