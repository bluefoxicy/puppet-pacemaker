#
#== Class: pacemaker::config
#
#Configures pacemaker through crm
#
class pacemaker::config::corosync {
  $authkey             = $pacemaker::authkey
  $bindnetaddr         = $pacemaker::bindnetaddr
  $communication_mode  = $pacemaker::communication_mode
  $mcastaddr           = $pacemaker::mcastaddr
  $port                = $pacemaker::port
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

  file { '/etc/corosync/service.d/pcmk':
    source      => 'puppet:///modules/pacemaker/corosync/service.d/pcmk',
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

  File <| tag == 'corosync' |>    ~>
  Service
    <|
      tag == 'corosync' or
      tag == 'pacemaker'
    |>
}
