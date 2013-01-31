#
#== Class: pacemaker
#
#Installs the pacemaker package and corosync cluster manager.
#
# Parameters:
# $communication_mode
#   'multicast' => use multicast
#   'broadcast' => use broadcast
# $mcastaddr
#   Address for multicast.  Select exactly 1 per cluster, used by all machines
#   in that cluster.
#
#   Recommend the local 239.255.0.0/16 scope.
#
#   Most non-multicast organizations should drop all multicast at all routers,
#   making it link-local.  Otherwise, it is recommended to select a
#   239.255.x.0/24 subnet to designate 'link-local scope' and drop it at all
#   routers.
#
#   Never use 239.255.128-255.0/8, ever.
#
#   Note:  the 224.0.0.0/8 subnet has lots of stuff for link-local management
#   assigned to it.  Never use tihs.
#
# $port
#   The multicast/broadcast port.
#
# $secauth
#   Whether to use HMAC and encryption.  This eats a lot of CPU but prevents
#   UDP spoof packets and eavesdropping.
#
# $totem_threads
#   Multi-thread when using secauth rather than waiting for encryption.
class pacemaker(
  $communication_mode  = $pacemaker::params::communication_mode,
  $mcastaddr           = $pacemaker::params::mcastaddr
  $port                = $pacemaker::params::mcastport,
  $secauth             = $pacemaker::params::secauth,
  $totem_threads       = $pacemaker::params::threads,
) inherits pacemaker::params {

#  if ( ! $authkey ) {
#    fail('Mandatory variable $authkey not set')
#  }

  include pacemaker::install
  include pacemaker::config
  include pacemaker::service

  service { 'corosync':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['corosync'],
  }

 Class['pacemaker::install'] ->
 Class['pacemaker::config']  ->
 Class['pacemaker::service']
}