# = Define: sentry::nrpe_service
#
# This define deploys checks run through nagios.
#
# == Parameters
#
# [* plugin *]
#   What plugin to use.
#
define sentry::nrpe_service (
  $plugin,
  $args
) {

  if (' ' in $name) {
    fail("name ${name} cannot contain spaces")
  }

  include nagios::server

  # definition of nrpe check in client's /etc/nagios/nrpe.d/nrpe-$name.cfg
  nagios::client::nrpe_file { "check_${name}":
    plugin => $plugin,
    args   => $args,
  }

  # definition of server-side nagios command to use nrpe client-side
  nagios_command { "check_nrpe_${name}":
    # -u turns socket timeout into unknowns
    command_line => "${nagios::server::nrpe} -u -c check_${name}"
  }

  # defition of server-side service name; needs to be unique by client name
  nagios::service { "${name}_nrpe_from_${::hostname}":
    check_command => "check_nrpe_${name}",
    use => "nrpe-service",

  }

}
