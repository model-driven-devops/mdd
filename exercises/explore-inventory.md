# Exploring the Inventory

![MDD Reference Topology](mdd_topo.png?raw=true "MDD Reference Topology")

## Inventory Sources

The inventory source in `ansible.cfg` is defined as `./inventory`.  This directory contains
files that define the Ansible Inventory for this repository.  There are two main sources
of inventory information: `network.yml` and `cml.yml`.  `network.yml` defines the
nodes in the topology, their relationship (hierarchy), and attributes (e.g. tags).  You
can see this topology by running `ansible-inventory`:

```
$ ansible-inventory --graph
SSL Verification disabled
@all:
  |--@network:
  |  |--@routers:
  |  |  |--@hq_routers:
  |  |  |  |--hq-rtr1
  |  |  |  |--hq-rtr2
  |  |  |--@internet_routers:
  |  |  |  |--internet-rtr1
  |  |  |--@site_routers:
  |  |  |  |--site1-rtr1
  |  |  |  |--site2-rtr1
  |  |--@switches:
  |  |  |--hq-sw1
  |  |  |--hq-sw2
  |  |  |--site1-sw1
  |  |  |--site2-sw1
  |--@nso:
  |  |--nso1
  |--@org:
  |  |--@region1:
  |  |  |--@hq:
  |  |  |  |--hq-rtr1
  |  |  |  |--hq-rtr2
  |  |  |  |--hq-sw1
  |  |  |  |--hq-sw2
  |  |  |--@site1:
  |  |  |  |--site1-rtr1
  |  |  |  |--site1-sw1
  |  |--@region2:
  |  |  |--@site2:
  |  |  |  |--site2-rtr1
  |  |  |  |--site2-sw1
  |--@system:
  |  |--@client:
  |  |  |--hq-host1
  |  |  |--site1-host1
  |  |  |--site2-host1
  |  |--@server:
  |  |  |--nso1
  |--@ungrouped:
  ```

  This command will work whether you've deployed the topology in CML or not since it comes directly
  from the Ansible inventory files.  If you do have the topology deployed, however, this inventory
  is augmented with the inventory in CML via the `cml.yml` file.  We can see what inventory is
  added by running `ansible-inventory` after the topology is started:

```
$ ansible-inventory --graph
SSL Verification disabled
@all:

  |--@cml_hosts:
  |  |--hq-host1
  |  |--hq-mgmt-bridge
  |  |--hq-mgmt-switch
  |  |--hq-rtr1
  |  |--hq-rtr2
  |  |--hq-sw1
  |  |--hq-sw2
  |  |--internet-mgmt
  |  |--internet-out
  |  |--internet-rtr1
  |  |--nso1
  |  |--site1-host1
  |  |--site1-mgmt-bridge
  |  |--site1-mgmt-switch
  |  |--site1-rtr1
  |  |--site1-sw1
  |  |--site2-host1
  |  |--site2-mgmt-bridge
  |  |--site2-mgmt-switch
  |  |--site2-rtr1
  |  |--site2-sw1
[...]
```
Notice that the group `cml_hosts` is added to the output for the device that are available in
CML.  This group can be used in playbooks to limit to device that are both in your inventory
and currently in CML.  In addition to the group `cml_hosts`, hosts are also placed in groups
as determined by their tags in CML.  The tags can be specified in `cml.yml` with the `group_tags`
option.

When the topology is up and running in CML, we can get the inventory including an IP address
assocated with that instance.

```
$ ansible-playbook cisco.cml.inventory
SSL Verification disabled
[WARNING]: running playbook inside collection cisco.cml

PLAY [cml_hosts] *************************************************************************************************************************************************************************************************

TASK [debug] *****************************************************************************************************************************************************************************************************
ok: [internet-rtr1] => {
    "msg": "Node: internet-rtr1(cat8000v), State: BOOTED, Address: 192.168.178.230"
}
ok: [hq-sw1] => {
    "msg": "Node: hq-sw1(iosvl2), State: BOOTED, Address: 192.168.178.227"
}
ok: [hq-sw2] => {
    "msg": "Node: hq-sw2(iosvl2), State: BOOTED, Address: 192.168.178.226"
}
ok: [site1-sw1] => {
    "msg": "Node: site1-sw1(iosvl2), State: BOOTED, Address: 192.168.178.229"
}
ok: [hq-rtr1] => {
    "msg": "Node: hq-rtr1(cat8000v), State: BOOTED, Address: 192.168.178.228"
}
ok: [hq-rtr2] => {
    "msg": "Node: hq-rtr2(cat8000v), State: BOOTED, Address: 192.168.178.222"
}
ok: [site1-rtr1] => {
    "msg": "Node: site1-rtr1(cat8000v), State: BOOTED, Address: 192.168.178.212"
}
ok: [site1-host1] => {
    "msg": "Node: site1-host1(ubuntu), State: BOOTED, Address: site1-host1"
}
ok: [hq-host1] => {
    "msg": "Node: hq-host1(ubuntu), State: BOOTED, Address: hq-host1"
}
ok: [internet-mgmt] => {
    "msg": "Node: internet-mgmt(external_connector), State: BOOTED, Address: internet-mgmt"
}
ok: [site2-rtr1] => {
    "msg": "Node: site2-rtr1(cat8000v), State: BOOTED, Address: 192.168.178.213"
}
ok: [site2-sw1] => {
    "msg": "Node: site2-sw1(iosvl2), State: BOOTED, Address: 192.168.178.231"
}
ok: [site2-host1] => {
    "msg": "Node: site2-host1(ubuntu), State: BOOTED, Address: site2-host1"
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
ok: [site2-mgmt-switch] => {
    "msg": "Node: site2-mgmt-switch(unmanaged_switch), State: BOOTED, Address: site2-mgmt-switch"
}
ok: [site2-mgmt-bridge] => {
    "msg": "Node: site2-mgmt-bridge(external_connector), State: BOOTED, Address: site2-mgmt-bridge"
}
ok: [nso1] => {
    "msg": "Node: nso1(ubuntu), State: BOOTED, Address: 192.168.178.221"
}
ok: [internet-out] => {
    "msg": "Node: internet-out(external_connector), State: BOOTED, Address: internet-out"
}

PLAY RECAP *******************************************************************************************************************************************************************************************************
hq-host1                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-mgmt-bridge             : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-mgmt-switch             : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-rtr1                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-rtr2                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-sw1                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hq-sw2                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
internet-mgmt              : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
internet-out               : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
internet-rtr1              : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
nso1                       : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-host1                : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-mgmt-bridge          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-mgmt-switch          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-rtr1                 : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-sw1                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-host1                : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-mgmt-bridge          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-mgmt-switch          : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-rtr1                 : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site2-sw1                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

Keep in mind that this is just the Ansible inventory and does not include the MDD Data.  For that,
please refer to the exercise [Exploring the Data](exercises/explore-data.md).

[Home](../README.md#workshop-exercises) | [Previous](initial-setup.md#initial-setup) | [Next](explore-data.md#exploring-the-data)