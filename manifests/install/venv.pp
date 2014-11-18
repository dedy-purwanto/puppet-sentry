class sentry::install::venv (
  $sentry_path,
  $virtualenv_path,
  $requirements_source
) {

    class { 'python::venv':
      owner => 'sentry',
      group => 'sentry'
    }

    python::venv::isolate { $virtualenv_path:
        requirements        => "${sentry_path}/requirements.txt",
        requirements_source => $requirements_source
    }
}
