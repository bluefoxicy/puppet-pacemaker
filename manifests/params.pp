#== Class: pacemaker::params
#
#Default parameters for pacemaker class
class pacemaker::params(
  $communication_mode  = 'multicast',
  $mcastaddr           = '239.255.1.1',   # Local scope 239.255.0.0/16
  $port                = '5405',
  $secauth             = 'on',
  $totem_threads       = '2',
  $crm_config          = undef,
  $crm_hash            = undef,
  $corosync_template   = 'templates/corosync/corosync.conf.erb'
) {

}
