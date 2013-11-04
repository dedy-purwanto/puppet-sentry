# = Class: sentry::nagios
#
# This class monitors sentry with nagios
#
#
class sentry::nagios (
  $web_port = 9100
) {
  sentry::nrpe_service { "sentry_${web_port}":
    plugin => 'check_http',
    args   => "-p ${web_port} localhost"
  }

  # FIXME: how do we make this conditional ?
  selinux::audit2allow { "nrpe_sentry_${web_port}":
    content => "type=AVC msg=audit(1383607078.429:934172): avc:  denied  { name_connect } for  pid=10171 comm=\"check_http\" dest=${web_port} scontext=unconfined_u:system_r:nrpe_t:s0 tcontext=system_u:object_r:hplip_port_t:s0 tclass=tcp_socket"
  }

}
