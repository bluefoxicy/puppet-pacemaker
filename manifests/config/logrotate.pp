#
# == Class: pacemaker::corosync
#
# $pacemaker_log_time_unit: a valid value for logrotate: daily, monthly, weekly
class pacemaker::corosync {
  # XXX:  Don't need these
  $authkey   = $::pacemaker::authkey
  $interface = $::pacemaker::interface
  $keepalive = $::pacemaker::keepalive
  $warntime  = $::pacemaker::warntime
  $deadtime  = $::pacemaker::deadtime
  $initdead  = $::pacemaker::initdead

  # TODO: put this variables in pacemaker::params

  if ( ! $corosync_mcast_ip      ) { fail("Mandatory variable \$corosync_mcast_ip not set") }
  if ( ! $corosync_mcast_port    ) { fail("Mandatory variable \$corosync_mcast_port not set") }
  if ( ! $corosync_authkey_file  ) { fail("Mandatory variable \$corosync_authkey_file not set") }
  if ( ! $corosync_conf_template ) { fail("Mandatory variable \$corosync_conf_template not set") }


  # For logrotate configuration
  if ( ! $pacemaker_logrotate_template ) { $pacemaker_logrotate_template = 'pacemaker/corosync.logrotate.erb' }
  if ( ! $logrotate_interval )  {
    $logrotate_interval = '1'
  }

  if ( ! $logrotate_unit ) {
    $logrotate_unit = 'daily'
  }


  file { "/etc/corosync/corosync.conf":
    owner   => "root",
    group   => "root",
    mode    => 0600,
    content => template("$corosync_conf_template"),
    require => Package["corosync"],
  }

  file { "/etc/corosync/authkey":
    owner   => "root",
    group   => "root",
    mode    => 0400,
    source  => $corosync_authkey_file,
    require => Package["corosync"],
  }

  file { '/etc/logrotate.d/corosync':
    ensure  => present,
    owner   => root,
    group   => root,
    content => template( $pacemaker_logrotate_template ),
    replace => false,
  }

  service { "corosync":
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }

}
