#
#== Class: pacemaker::config
#
#Configures pacemaker through crm
#
class pacemaker {
  $authkey             = $pacemaker::authkey
  $bindnetaddr         = $pacemaker::bindnetaddr
  $communication_mode  = $pacemaker::communication_mode
  $mcastaddr           = $pacemaker::mcastaddr
  $port                = $pacemaker::mcastport
  $secauth             = $pacemaker::secauth
  $totem_threads       = $pacemaker::threads
  $crm_config          = $pacemaker::crm_config
  $crm_hash            = $pacemaker::crm_hash
  $corosync_template   = $pacemaker::corosync_template

  file { '/etc/corosync/corosync.conf':
    content     => template($corosync_template),
    owner       => 'root',
    group       => 'root',
    mode        => '0444',
    tag         => 'corosync',
  }

  file { '/etc/corosync/authkey':
    source      => $authkey,
    owner       => 'root',
    group       => 'root',
    mode        => '0444',
    tag         => 'corosync',
  }

  File <| tag == 'corosync' |>    ->
  Service <| tag == 'corosync' |>
}
