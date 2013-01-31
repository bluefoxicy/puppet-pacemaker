#
# pacemaker::primitive::ipaddr type
#
# This is a shortcut to create a cluster IP address that moves around
#
define pacemaker::primitive::ipaddr(
  ip,
  name     = $title,
  interval = '30s',
) {

  if ( $ip == undef ) {
    fail('Did not receive required parameter $ip to pacemaker::primitive::ipaddr')
  }

  pacemaker::primitive { $title:
    standard  => 'ocf',
    namespace => 'heartbeat',
    resource  => 'IPaddr2',
    name      => $name,
    params    =>
      {
        'ip'           => $ip,
        'cidr_netmask' => '32',
      },
    ops       =>
      {
        'monitor' =>
          {
            interval    => $interval,
          }
      }
  }
}
