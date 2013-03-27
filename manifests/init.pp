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
#
# $crm_config
#   Path to a template file to use as a configuration loaded via crm before
#   anything else is run.
#
# $crm_hash
#   Optional.  Data for the template.
class pacemaker(
  $bindnetaddr,
  $authkey             = undef,
  $communication_mode  = $pacemaker::params::communication_mode,
  $mcastaddr           = $pacemaker::params::mcastaddr,
  $port                = $pacemaker::params::port,
  $secauth             = $pacemaker::params::secauth,
  $totem_threads       = $pacemaker::params::threads,
  $crm_config          = $pacemaker::params::crm_config,
  $cib_config          = $pacemaker::params::cib_config,
  $config_hash         = $pacemaker::params::config_hash,
  $corosync_template   = $pacemaker::params::corosync_template,
) inherits pacemaker::params {

  if ( $secauth == 'on' and ! $authkey ) {
    fail('Mandatory variable $authkey not set')
  }

  include pacemaker::install
  include pacemaker::config
  include pacemaker::service

  Class['pacemaker::install'] ->
  Class['pacemaker::config']  ->
  Class['pacemaker::service']
}
