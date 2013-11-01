# = Class: sentry::nagios
#
# This class monitors sentry with nagios
#
#
class sentry::nagios (
  $web_port
) {
    nagios::service { "sentry_${::hostname}":
    check_command => 'check_http!-p 9100 localhost',
  }

  
}
