# Pushing Data

## Dependencies

See [Initial Setup](exercises/initial-setup.md)
See [Deploying the Topology](exercises/deploy-topology.md)

## Overview

![Push Data](overview-push-data.png?raw=true "Push Data")

At this point in the pipeline, we've generated the device specific data and
validated that data.  We are now ready to push that data into the device.

## Procedure

### Dry Run (optional)

We can do a dry run to push the data to all devices, a subset of devices, or
a single device.  The dry run will calculate what changes need to be made and
give a report of the specif changes that will be made to the devices.  To perform
a dry run, do:

```
ansible-playbook ciscops.mdd.nso_update_oc
```

Here is a truncated version of the output to illustrate what the playbook does:

```
TASK [ciscops.mdd.data : Combine the MDD Data] ********************************************************************
ok: [hq-sw1]
ok: [site1-sw1]
ok: [hq-sw2]
ok: [hq-rtr1]
ok: [site2-sw1]
ok: [hq-rtr2]
ok: [site1-rtr1]
ok: [site2-rtr1]

TASK [include_role : ciscops.mdd.nso] *****************************************************************************

TASK [ciscops.mdd.nso : Check if device is in sync] ***************************************************************
ok: [hq-sw1]
ok: [site1-sw1]
ok: [site2-sw1]
ok: [hq-sw2]
ok: [hq-rtr1]
ok: [hq-rtr2]
ok: [site1-rtr1]
ok: [site2-rtr1]

TASK [Update OC Data] *********************************************************************************************

TASK [ciscops.mdd.nso : Update OC Service] ************************************************************************
ok: [hq-sw2]
ok: [hq-rtr1]
ok: [hq-sw1]
ok: [site2-sw1]
ok: [site1-sw1]
ok: [site1-rtr1]
ok: [hq-rtr2]
ok: [site2-rtr1]

PLAY [Run update_report] ******************************************************************************************

TASK [Update OC Data] *********************************************************************************************

TASK [ciscops.mdd.nso : debug] ************************************************************************************
ok: [internet-rtr1] => {
    "update_report": {
        "consolidated_report": null
    }
}

PLAY RECAP ********************************************************************************************************
hq-rtr1                    : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-rtr2                    : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-sw1                     : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-sw2                     : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
internet-rtr1              : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-rtr1                 : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site1-sw1                  : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site2-rtr1                 : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site2-sw1                  : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0 
```

First, the playbook combines the data as explained in [Exploring the Data](exercises/explore-data.md) to create the device-specific payload.  Second, it checks that all the devices are in sync with NSO to make sure that there were not any manual changes made.  If manual changes were made, that host would error out and no new updated would be pushed to the device until the conflict was resolved and the device brought back into sync with NSO.  Third, it pushes the data to NSO.  By default, the `ciscops.mdd.nso_update_oc`.  Since we did not override that behavior,
NSO will perform a dry run and report back what changes it would make to the device.  Last, the playbook consolidates the changes into a report to consolidate the changes made with the group of devices that changes were made on. Since `consolidated_report` was `null`, there were no updates that needed to pushed out to the devices.

### Single device change

Let's look at making a change that affects a single device.  A common change of this type would be to enable an interface and add it to a VLAN.  We'll do that by adding interface `GigabitEthernet1/1` into vlan 10 on `site2-sw1` by modifying the interface data under `openconfig-interfaces:interface` in `mdd-data/org/region2/site2/site2-sw1/oc-intefaces.yml`
to be: 

```
      - config:
          enabled: true
          name: GigabitEthernet1/1
          type: l2vlan
        name: GigabitEthernet1/1
        openconfig-if-ethernet:ethernet:
          openconfig-vlan:switched-vlan:
            config:
              access-vlan: 10
              interface-mode: ACCESS
```

When we perform a dry run, we see the change that will be pushed out.

```
TASK [ciscops.mdd.nso : debug] *************************************************************************************************************************************************************************************************************************************************
ok: [internet-rtr1] => {
    "update_report": {
        "consolidated_report": [
            {
                "data": "interface GigabitEthernet1/1 switchport switchport mode access switchport access vlan 10 exit ",
                "hosts": "['site2-sw1']"
            }
        ]
    }
}

PLAY RECAP *********************************************************************************************************************************************************************************************************************************************************************
hq-rtr1                    : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-rtr2                    : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-sw1                     : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-sw2                     : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
internet-rtr1              : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-rtr1                 : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site1-sw1                  : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site2-rtr1                 : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site2-sw1                  : ok=16   changed=1    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
```

Notice that site2-sw1 is the only device that changes.  Since we know that we are only pushing out a change to site2-sw1,
we can push it to that device specifically by limiting the scope of tha Ansible playbook:

```
ansible-playbook ciscops.mdd.nso_update_oc -e dry_run=no --limit=site2-sw1
```

```
TASK [ciscops.mdd.nso : Update OC Service] ************************************************************************
changed: [site2-sw1]

TASK [ciscops.mdd.nso : set_fact] *********************************************************************************
ok: [site2-sw1]

TASK [ciscops.mdd.nso : debug] ************************************************************************************
ok: [site2-sw1] => {
    "msg": "Rollback Id: 10036"
}

PLAY [Run update_report] ******************************************************************************************

PLAY RECAP ********************************************************************************************************
site2-sw1                  : ok=17   changed=1    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
```

We can see that the change was pushed out and are given a Rollback Id of 10036.  This Rollback ID allows us to roll back this last change if it turns out to have a mistake and/or broke something on the network.  We can rollback using the `ciscops.mdd.nso_rollback` playbook:

```
ansible-playbook ciscops.mdd.nso_rollback -e rollback_id=10036
```

### Multi-Device Change

Next, let's make a change the affects several devices.  We'll do another common change: Adding a VLAN.  This time, we'll make a change to the org-level file `mdd-data/org/oc-vlan.yml` so that the change is pushed out to all switches:

```
---
mdd_tags:
  - switch
mdd_data:
  openconfig-network-instance:network-instances:
    openconfig-network-instance:network-instance:
      - name: 'default'
        config:
          name: 'default'
          type: 'DEFAULT_INSTANCE'
          enabled: true
        vlans:
          vlan:
            - vlan-id: 10
              config:
                vlan-id: 10
                name: 'Internal-1'
                status: 'ACTIVE'
            - vlan-id: 100
              config:
                vlan-id: 100
                name: 'Corporate'
                status: 'ACTIVE'
            - vlan-id: 101
              config:
                vlan-id: 101
                name: 'Guest'
                status: 'ACTIVE'
```

As you can see, this data will only get applied to devices that are tagged as `switch1`.  We'll add VLAN 20 by adding the following data under `openconfig-network-instance:network-instance`:

```
            - vlan-id: 20
              config:
                vlan-id: 20
                name: 'Internal-2'
```

We can now perform a dry run to see what changes will be made in the network:

```
TASK [Update OC Data] *********************************************************************************************

TASK [ciscops.mdd.nso : set_fact] *********************************************************************************
ok: [internet-rtr1]

TASK [ciscops.mdd.nso : debug] ************************************************************************************
ok: [internet-rtr1] => {
    "update_report": {
        "consolidated_report": [
            {
                "data": "vlan 20 name Internal-2 ! ",
                "hosts": "['hq-sw1', 'hq-sw2', 'site1-sw1', 'site2-sw1']"
            }
        ]
    }
}

PLAY RECAP ********************************************************************************************************
hq-rtr1                    : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-rtr2                    : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-sw1                     : ok=16   changed=1    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
hq-sw2                     : ok=16   changed=1    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
internet-rtr1              : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
site1-rtr1                 : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site1-sw1                  : ok=16   changed=1    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site2-rtr1                 : ok=16   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
site2-sw1                  : ok=16   changed=1    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0   
```

As you can see, the change only affected the devices tagged as a `switch`.  Since the same change was pushed to multiple devices, the consolidated report only listed it once.  Since no other devices were changed, they were not included in the report.  When we push out the change, we get the Rollback Ids for the changes:

```
TASK [ciscops.mdd.nso : debug] *************************************************************************************************************************************************************************************************************************************************
ok: [hq-sw1] => {
    "msg": "Rollback Id: 10049"
}
ok: [hq-sw2] => {
    "msg": "Rollback Id: 10050"
}
ok: [site1-sw1] => {
    "msg": "Rollback Id: 10047"
}
ok: [site2-sw1] => {
    "msg": "Rollback Id: 10048"
}
```

But what if we want to rollback an entire change?

### Checkpoint/Rollback

In order to rollback multiple changes at once, we have to perform a checkpoint operation befire we make the changes.  To do that, we run the `ciscops.mdd.nso_save_rollback`:

```
ansible-playbook ciscops.mdd.nso_save_rollback
```

This drop the current Rollback ID into a file called `rollback.yaml`, but it can be overridden with extra vars. If the playbook is run a second time, it will drip the latest Rollback ID into the file, losing the previous one.  To rollback to this checkpoint, run the playbook `ciscops.mdd.nso_load_rollback`:

```
ansible-playbook ciscops.mdd.nso_load_rollback
```

This playbook will return the network to the state that it was when `ciscops.mdd.nso_save_rollback` by loading the Rollback ID that immediatly follows the one that is in `rollback.yaml`, since rolling back to the one listed in `rollback.yaml` would return the network to the state it was at the change before the changes about to  be made.
