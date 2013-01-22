class sentry::service (
  $method = 'supervisor',
  $path   = '/var/sentry'
) {
    $virtualenv_path = "$path/virtualenv"

    case $method {
        'supervisor': {
            class { "sentry::service::$method":
                sentry_path => $path,
                virtualenv_path => $virtualenv_path
            }
        }
    }

}
