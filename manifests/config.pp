#
#== Class: pacemaker::config
#
#Configures pacemaker through crm
#
class pacemaker {
  $bindnetaddr         = $pacemaker::bindnetaddr
  $communication_mode  = $pacemaker::communication_mode
  $mcastaddr           = $pacemaker::mcastaddr
  $port                = $pacemaker::mcastport
  $secauth             = $pacemaker::secauth
  $totem_threads       = $pacemaker::threads
  $crm_config          = $pacemaker::crm_config
  $crm_hash            = $pacemaker::crm_hash


}
