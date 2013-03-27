#
#== Class: pacemaker::config::crm
#
#Configures pacemaker through crm
#
class pacemaker::config::crm {
  $crm_config          = $pacemaker::crm_config
  $config_hash         = $pacemaker::config_hash

  exec { 'dump crm config':
    command     => 'crm configure save /etc/corosync/config.crm',
    onlyif      => 'rm -f /etc/corosync/config.crm',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    tag         => 'pre-crm',
  }

  file { '/etc/corosync/config.crm':
    content     => template($crm_config),
    owner       => 'root',
    group       => 'root',
    mode        => '0644',
    tag         => 'crm',
  }

  exec { 'load crm config':
    command     => 'crm configure property stop-all-resources=true ; crm configure load replace /etc/corosync/config.crm',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
    tag         => 'post-crm',
  }

  Package <| tag == 'pacemaker' |>   ->
  Exec <| tag == 'pre-crm' |>        ->
  File <| tag == 'crm' |>            ~>
  Exec <| tag == 'post-crm' |>

  Service <| tag == 'pacemaker' |>   ->
  Exec <| tag == 'pre-crm' |>
}
