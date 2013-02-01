#
#== Class: pacemaker::service
#
# Starts the pacemaker and corosync services
#
class pacemaker::service { 
  service { 'corosync':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['corosync'],
    tag       => 'corosync',
  }

  service { 'pacemaker':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['pacemaker'],
    tag       => 'pacemaker',
  }

  Package <| tag == 'corosync' |> ->
  Service <| tag == 'corosync' |>

  Package <| tag == 'pacemaker' |> ->
  Service <| tag == 'pacemaker' |>

  Service['corosync']  ->
  Service['pacemaker']
}
