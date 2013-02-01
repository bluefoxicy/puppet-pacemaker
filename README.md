puppet-pacemaker
================

A module to configure Pacemaker

Originally was based on camptocamp/puppet-pacemaker, but at some point
I ripped out the whole thing and started over.

The general configuration sets up Corosync and Pacemaker.  After that,
defined types run crm commands to configure the node.

example
=======

```puppet
node /^cluster-\d+\.example\.com$/ {
  class { pacemaker:
    bindnetaddr => '10.0.50.0',                # mandatory
    mcastaddr   => '239.255.1.1',
    crm_config  => "$templatedir/crm-cl0.erb", # per-environment
    crm_hash    => hiera('crm_config'),
  }
}
```

templates
=========

This module allows you to make a template that doesn't restart the cluster if
configuration has not changed.  The template starts from the output of

```shell
  # crm configure save config.crm
```

For example, if the above command produced a config.crm as follows:

```
node pcmk-1.clusterlabs.org
node pcmk-2.clusterlabs.org
primitive ClusterIP ocf:heartbeat:IPaddr2 \
	params ip="10.99.100.254" cidr_netmask="32" \
	op monitor interval="30s"
property $id="cib-bootstrap-options" \
	dc-version="1.1.7-6.el6-148fccfd5985c5590cc601123c6c16e966b85d14" \
	cluster-infrastructure="openais" \
	expected-quorum-votes="2" \
	stonith-enabled="false" \
	no-quorum-policy="ignore"
rsc_defaults $id="rsc-options" \
	resource-stickiness="100"
```

You could create a template such as template/crm.example.erb to produce the
same configuration.  Puppet would pass a hash generated either in the node
configuration or from Hiera, consisting of:

```puppet
$crm_hash =
  {
    nodes =>
      [
        'pcmk-1',
        'pcmk-2',
      ],
    ip_resource =>
      {
        ClusterIP0 => { address => '10.0.50.100', interval => '30s' },
      },
    stickiness  => '100',
    quorum      => '0',
  }
```

Running this against the supplied template would produce the same output as
from crm.  The module dumps the crm configuration and checks it to test.

It is of course possible to supply a $crm_template that isn't a template, and
an empty $crm_hash.

In any case, if the final configuration is not identical to the output of crm,
puppet will stop all resources on the cluster briefly to reload the
configuration.  You can handle this by

 - Making your configuration identical to a properly configured node; or
 - Using mcollective to push configuration changes, rather than polling


