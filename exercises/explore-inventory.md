# Exploring the Inventory

In this exercise you will explore the Ansible inventory. For this lab, the inventory source is set in `ansible.cfg` and is defined as `./inventory`. This directory contains files that define the Ansible inventory for this repository.  There are two main sources of inventory information: `network.yml` and `cml.yml`.  `network.yml` defines the nodes in the topology, their relationship (hierarchy), and attributes (e.g. tags).

You can see this structure by running `ansible-inventory` on the "network" group:

```
ansible-inventory --graph network
```

Expected output:

```
SSL Verification disabled
@network:
  |--@WAN_routers:
  |  |--WAN-rtr1
  |--@routers:
  |  |--@hq_routers:
  |  |  |--hq-pop
  |  |  |--hq-rtr1
  |  |  |--hq-rtr2
  |  |--@site_routers:
  |  |  |--site1-rtr1
  |  |  |--site2-rtr1
  |--@switches:
  |  |--hq-sw1
  |  |--hq-sw2
  |  |--site1-sw1
  |  |--site2-sw1
```

This command will work whether you've deployed the topology in CML or not since it comes directly from the Ansible inventory files. If you do have the topology deployed, however, this inventory is augmented with the inventory in CML via the `cml.yml` file. We can see what inventory is added by running `ansible-inventory` on the "cml_hosts" group after the topology is started:

```
ansible-inventory --graph cml_hosts
```

Expected output:

```
@cml_hosts:
  |--ISP
  |--ISP-mgmt-bridge
  |--WAN-mgmt
  |--WAN-rtr1
  |--hq-mgmt-bridge
  |--hq-mgmt-switch
  |--hq-pop
  |--hq-rtr1
  |--hq-rtr2
  |--hq-sw1
  |--hq-sw2
  |--internet-out
  |--site1-mgmt-bridge
  |--site1-mgmt-switch
  |--site1-rtr1
  |--site1-sw1
  |--site2-mgmt-bridge
  |--site2-mgmt-switch
  |--site2-rtr1
  |--site2-sw1
```

Notice that the group `cml_hosts` is added to the output for the devices that are available in CML. This group can be used to limit playbooks to devices that are both in your inventory and currently in CML. In addition to the group `cml_hosts`, hosts are also placed in groups as determined by their tags in CML.  The tags can be specified in `cml.yml` with the `group_tags` option.

When the topology is up and running in CML, we can get the inventory including an IP address assocated with that instance:

```
ansible-playbook cisco.cml.inventory
```

Expected output:

```
PLAY [cml_hosts] *************************************************************************************************************************************************

TASK [debug] *****************************************************************************************************************************************************
ok: [WAN-rtr1] => {
    "msg": "Node: WAN-rtr1(csr1000v), State: BOOTED, Address: 10.10.20.131"
}
ok: [hq-sw2] => {
    "msg": "Node: hq-sw2(iosvl2), State: BOOTED, Address: 10.10.20.133"
}
ok: [hq-sw1] => {
    "msg": "Node: hq-sw1(iosvl2), State: BOOTED, Address: 10.10.20.132"
}
ok: [site1-sw1] => {
    "msg": "Node: site1-sw1(iosvl2), State: BOOTED, Address: 10.10.20.134"
}
ok: [hq-rtr1] => {
    "msg": "Node: hq-rtr1(csr1000v), State: BOOTED, Address: 10.10.20.135"
}
ok: [site1-rtr1] => {
    "msg": "Node: site1-rtr1(csr1000v), State: BOOTED, Address: 10.10.20.137"
}
ok: [hq-rtr2] => {
    "msg": "Node: hq-rtr2(csr1000v), State: BOOTED, Address: 10.10.20.136"
}
ok: [WAN-mgmt] => {
    "msg": "Node: WAN-mgmt(external_connector), State: BOOTED, Address: WAN-mgmt"
}
ok: [site2-rtr1] => {
    "msg": "Node: site2-rtr1(csr1000v), State: BOOTED, Address: 10.10.20.138"
}
ok: [site2-sw1] => {
    "msg": "Node: site2-sw1(iosvl2), State: BOOTED, Address: 10.10.20.139"
}
ok: [hq-mgmt-bridge] => {
    "msg": "Node: hq-mgmt-bridge(external_connector), State: BOOTED, Address: hq-mgmt-bridge"
}
ok: [hq-mgmt-switch] => {
    "msg": "Node: hq-mgmt-switch(unmanaged_switch), State: BOOTED, Address: hq-mgmt-switch"
}
ok: [site1-mgmt-switch] => {
    "msg": "Node: site1-mgmt-switch(unmanaged_switch), State: BOOTED, Address: site1-mgmt-switch"
}
ok: [site1-mgmt-bridge] => {
    "msg": "Node: site1-mgmt-bridge(external_connector), State: BOOTED, Address: site1-mgmt-bridge"
}
ok: [site2-mgmt-bridge] => {
    "msg": "Node: site2-mgmt-bridge(external_connector), State: BOOTED, Address: site2-mgmt-bridge"
}
ok: [site2-mgmt-switch] => {
    "msg": "Node: site2-mgmt-switch(unmanaged_switch), State: BOOTED, Address: site2-mgmt-switch"
}
ok: [hq-pop] => {
    "msg": "Node: hq-pop(csr1000v), State: BOOTED, Address: 10.10.20.140"
}
ok: [internet-out] => {
    "msg": "Node: internet-out(external_connector), State: BOOTED, Address: internet-out"
}
ok: [ISP-mgmt-bridge] => {
    "msg": "Node: ISP-mgmt-bridge(external_connector), State: BOOTED, Address: ISP-mgmt-bridge"
}
ok: [ISP] => {
    "msg": "Node: ISP(csr1000v), State: BOOTED, Address: ISP"
}

PLAY RECAP *******************************************************************************************************************************************************
ISP                        : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ISP-mgmt-bridge            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
WAN-mgmt                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
WAN-rtr1                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-mgmt-bridge             : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-mgmt-switch             : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-pop                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-rtr1                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-rtr2                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-sw1                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-sw2                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
internet-out               : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-mgmt-bridge          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-mgmt-switch          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-rtr1                 : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-sw1                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-mgmt-bridge          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-mgmt-switch          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-rtr1                 : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-sw1                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

If you just want to see the inventory data for a single device, use the Ansible `--limit` parameter:

```
ansible-playbook cisco.cml.inventory --limit hq-rtr1
```

Expected output:

```
PLAY [cml_hosts] *************************************************************************************************************************************************

TASK [debug] *****************************************************************************************************************************************************
ok: [hq-rtr1] => {
    "msg": "Node: hq-rtr1(csr1000v), State: BOOTED, Address: 10.10.20.135"
}

PLAY RECAP *******************************************************************************************************************************************************
hq-rtr1                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Keep in mind that this is just the Ansible inventory of devices and *does not* include the configuration for the devices (ie. the Source of Truth). That data is stored in the MDD data directory, which we will explore in the next exercise.

[Home](../README.md#workshop-exercises) | [Previous](deploy-topology.md#deploy-the-topology) | [Next](explore-data.md#exploring-the-data)
