# service class to be used with
# https://github.com/plathrop/puppet-module-supervisor
class sentry::service::supervisor (
  $sentry_path,
  $virtualenv_path
) {

  include supervisor

  supervisor::service {
    'sentry':
      ensure      => present,
      enable      => true,
      command     => "${virtualenv_path}/bin/sentry --config=${sentry_path}/sentry.conf.py start http",
      directory   => $sentry_path,
      user        => 'sentry',
      group       => 'sentry',
      require     => [ Class['sentry::install'] ]
  }

}
