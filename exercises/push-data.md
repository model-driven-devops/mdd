# Pushing Data


At this point in the pipeline, we've generated the device specific data and
validated it. We are now ready to push the validated data into the devices.

![Push Data](overview-push-data.png?raw=true "Push Data")

## Dry Run

You can optionally do a dry run to push the data to all devices, a subset of devices, or a single device. The dry run will calculate what changes need to be made and give a report of the specific changes that would be made to the devices. To perform a dry run, use:

```
ansible-playbook ciscops.mdd.update
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

The playbook performs the following tasks:

1. It combines the data as explained in the Explore the Data exercise to create the device-specific payload.
2. It checks that all of the devices are in sync with NSO to make sure that there were not any manual changes made out-of-band. If manual changes were made, that host would error out and no new update would be pushed to the device until the conflict was resolved and the device brought back into sync with NSO.
3. It pushes the data to NSO. By default, the ```ciscops.mdd.update``` performs a dry run.  Since we did not override that behavior, NSO will perform a dry run and report back what changes it would make to the device.
4. It consolidates the changes into a report to consolidate the changes made with the group of devices that changes were made on. Since `consolidated_report` was `null`, there were no updates that needed to pushed out to the devices.

## Single Device Change

Let's look at making a change that affects a single device. A common change of this type would be to enable an interface and add it to a VLAN.  We'll do that by adding interface ```GigabitEthernet1/1``` into vlan 10 on ```site2-sw1``` by modifying the interface data in its `oc-intefaces.yml`. Copy the updated interface configuration of site2-sw1 into the file `mdd-data/org/region2/site2/site2-sw1/oc-intefaces.yml`:

```
cp files/oc-interfaces-new.yml mdd-data/org/region2/site2/site2-sw1/oc-interfaces.yml
```

This file contains the following changed data.  View the file in the editor to verify.

```
$ diff files/oc-interfaces.yml files/oc-interfaces-new.yml 
54c54,59
<           openconfig-interfaces:type: ethernetCsmacd
---
>           openconfig-interfaces:type: l2vlan
>         openconfig-if-ethernet:ethernet:
>           openconfig-vlan:switched-vlan:
>             openconfig-vlan:config:
>               openconfig-vlan:access-vlan: 10
>               openconfig-vlan:interface-mode: ACCESS
```

Then perform a dry run:

```
ansible-playbook ciscops.mdd.update
```

And see the change that would be pushed out:

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

Notice that site2-sw1 is the only device that changes. Since we know that we are only pushing out a change to site2-sw1, we can push it to that device specifically by limiting the scope of tha Ansible playbook:

```
ansible-playbook ciscops.mdd.update -e dry_run=no --limit=site2-sw1
```

The truncated output below shows that the change was successful:

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

You can see that the change was pushed out and we are given a rollback ID (10036 in this example). This rollback ID allows us to roll back this last change if it turns out to have a mistake and/or broke something on the network.  Make a note of the rollback ID you get when running the playbook. You will use it later to rollback this change.

Let's verify that this change was actually made. Find the IP address of `site2-sw1`:

```
ansible-playbook cisco.cml.inventory --limit site2-sw1
```

Then login to the device using SSH with username admin and password admin (substitute your `site2-sw1` IP address here):

```
$ ssh admin@192.133.151.134
Password:
Welcome to site2-sw1

site2-sw1#
```

And verify the interface configuration:

```
show run int gig1/1
```

Now, exit out of the SSH session to `site2-sw1` and rollback the configuration with the ```ciscops.mdd.nso_rollback``` playbook (use your rollback ID, NOT the one shown below):

```
ansible-playbook ciscops.mdd.nso_rollback -e rollback_id=10036
```
> Note: update the rollback ID to match the one shown in your terminal output for the previous step.

If you would like, you can SSH to `site2-sw1` again to verify that the changes were rolled back.

Now reset the site2-sw1 interfaces back to the original values:

```
cp files/oc-interfaces.yml mdd-data/org/region2/site2/site2-sw1/oc-interfaces.yml
```

## Multi-Device Changes

Next, let's make a change that effects several devices. For this, we will do another common change: Adding a VLAN. This time, we'll make a change to the org-level file `mdd-data/org/oc-vlan.yml` so that the change is pushed out to all switches. Verify the current contents of the `mdd-data/org/oc-vlan.yml` file in the editor.

```yaml
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

Because we set ```mdd_tags``` to ```switch```, this data will only get applied to devices that are tagged as ```switch```. We'll add VLAN 20 by adding the following data to the list of vlans in ```openconfig-network-instance:network-instance```.

Copy the updated vlan configuration into the file `mdd-data/org/oc-vlan.yml`:

```
cp files/oc-vlan-new.yml mdd-data/org/oc-vlan.yml
```

This file contains the following additional data. View the file in the editor to verify.

```
$ diff files/oc-vlan.yml files/oc-vlan-new.yml 
18a19,23
>             - openconfig-network-instance:vlan-id: 20
>               openconfig-network-instance:config:
>                 openconfig-network-instance:vlan-id: 20
>                 openconfig-network-instance:name: 'Internal-2'
>                 openconfig-network-instance:status: 'ACTIVE'
```

We can now perform a dry run to see what changes will be made in the network:

```
ansible-playbook ciscops.mdd.update
```

And get the following truncated output:

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

As you can see, the change only affected the devices tagged as a `switch`. Since the same change was pushed to multiple devices, the consolidated report only listed it once. Since no other devices were changed, they were not included in the report. If we push out these changes without a dry run, we would get the rollback IDs for the changes:

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

## Checkpoint/Rollback

In order to rollback multiple changes at once, we have to perform a checkpoint operation before we make the changes.  To do that, we run the ```ciscops.mdd.nso_save_rollback```:

```
ansible-playbook ciscops.mdd.nso_save_rollback
```

This drops the current rollback ID into a file called `rollback.yaml`, but it can be overridden with extra vars. If the playbook is run a second time, it will drop the latest rollback ID into the file, losing the previous one.  To rollback to this checkpoint, run the playbook ```ciscops.mdd.nso_load_rollback```:

```
ansible-playbook ciscops.mdd.nso_load_rollback
```

This playbook will return the network to the state that it was in when ```ciscops.mdd.nso_save_rollback``` was run.

[Home](../README.md#workshop-exercises) | [Previous](data-validation.md#data-validation) | [Next](check-state.md#state-checking)