#
#== Class: pacemaker::config::crm
#
#Configures pacemaker through crm
#
class pacemaker::config::crm {
  $crm_config          = $pacemaker::crm_config
  $crm_hash            = $pacemaker::crm_hash

  exec { 'dump crm config':
    command     => 'crm configure save /etc/corosync/config.crm',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    tag         => 'pre-crm',
  }

  file { '/etc/corosync/config.crm':
    content     => template($crm_config),
    owner       => 'root',
    group       => 'root',
    mode        => '0400',
    tag         => 'crm',
  }

  exec { 'load crm config':
    command     => 'crm configure load replace /etc/corosync/config.crm',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
    tag         => 'post-crm',
  }

  Package <| tag == 'pacemaker' |> ->
  Exec <| tag == 'pre-crm' |>      ->
  File <| tag == 'crm' |>          ~>
  Exec <| tag == 'post-crm' |>
}
