# Exploring the Data
Although we leverage the Ansible inventory for some things, we also use a separate set of data in the `mdd-data` directory. An Ansible role called `ciscops.mdd.data` uses the `mdd-data` directory to construct the data needed to configure devices. We do this because the large about of data necessary to configure modern networks would be difficult to manage with the way the Ansible inventory system works. This method allows the tool to read just the data that is needed into the device's context and for that data to be organized in a deterministic hierarchy.

In order to make it easy to leverage, the role can be called in the roles sections of the playbook. For example, here is a simple playbook (`ciscops.mdd.show`) that displays the data constructed for a particular device:

```yaml
- hosts: network
  connection: local
  gather_facts: no
  roles:
    - ciscops.mdd.data
  tasks:
    - debug:
        var: mdd_data
```

Notice that the invocation of the `ciscops.mdd.data` creates the `mdd_data` data structure that contains the device's configuration data that can be used later in the playbook.

We use a separate directory hierarchy to hold the MDD data in the `mdd-data` directory (this can be changed in the defaults). You can see how the data is laid out in the `mdd-data` directory using the `tree` command.  (Note: this command is not installed on the DevBox and will fail, but you can see the output below.)

```
tree -d mdd-data
```

Expected output:

```
mdd-data
├── ISP
│   └── ISP
└── org
    ├── region1
    │   ├── hq
    │   │   ├── hq-pop
    │   │   ├── hq-rtr1
    │   │   ├── hq-rtr2
    │   │   ├── hq-sw1
    │   │   ├── hq-sw2
    │   │   └── WAN-rtr1
    │   └── site1
    │       ├── site1-rtr1
    │       └── site1-sw1
    └── region2
        └── site2
            ├── site2-rtr1
            └── site2-sw1
```

This aligns with the way that the devices are organized in the Ansible inventory:

```
ansible-inventory --graph org
```

Expected output:

```
@org:
  |--@region1:
  |  |--@hq:
  |  |  |--WAN-rtr1
  |  |  |--hq-pop
  |  |  |--hq-rtr1
  |  |  |--hq-rtr2
  |  |  |--hq-sw1
  |  |  |--hq-sw2
  |  |--@site1:
  |  |  |--site1-rtr1
  |  |  |--site1-sw1
  |--@region2:
  |  |--@site2:
  |  |  |--site2-rtr1
  |  |  |--site2-sw1
```

Data at the deeper levels of the tree (closer to the device) take precendense over data closer to the root of the tree. Each of the files in the heiracrhy are named by their purpose and content. For OpenConfig data, the filenames begin with `oc-` (although this is configurable). For example, the file `mdd-data/org/oc-ntp.yml` contains the organization level NTP configuration:

```yaml
---
mdd_data:
  openconfig-system:system:
    openconfig-system:clock:
      openconfig-system:config:
        openconfig-system:timezone-name: 'PST -8 0'
    openconfig-system:ntp:
      openconfig-system:config:
        openconfig-system:enabled: true
      openconfig-system:servers:
        openconfig-system:server:
          - openconfig-system:address: '216.239.35.0'
            openconfig-system:config:
              openconfig-system:address: '216.239.35.0'
              openconfig-system:association-type: SERVER
              openconfig-system:iburst: true
          - openconfig-system:address: '216.239.35.4'
            openconfig-system:config:
              openconfig-system:address: '216.239.35.4'
              openconfig-system:association-type: SERVER
              openconfig-system:iburst: true
```

The OpenConfig data is collected under the `mdd_data` key. While this file just includes the OC data to define NTP, it will later be combined with the rest of the OC data to create the full data payload. Since this data is at the root of the hierarchy, it can be overridden by anything else closer to the device. If we want to set `timezone-name` to something specific to a particular region, we can override it at the region level. For example, `mdd-data/org/region2/oc-ntp.yml` contains:

```yaml
---
mdd_data:
  openconfig-system:system:
    openconfig-system:clock:
      openconfig-system:config:
        openconfig-system:timezone-name: 'EST -5 0'
```

This file only contains the data needed to override specific values and the approriate structure to place it in context of the overall data model.

To see the effect this has on the data, run the following:

```
ansible-playbook ciscops.mdd.show --limit=site1-rtr1
```

In particular, note the timezone data for `site1-rtr1`:

```yaml
            "openconfig-system:clock": {
                "openconfig-system:config": {
                    "openconfig-system:timezone-name": "PST -8 0"
                }
            },
```

And compare to:

```
ansible-playbook ciscops.mdd.show --limit=site2-rtr1
```

The timezone data for `site2-rtr1`:

```yaml
            "openconfig-system:clock": {
                "openconfig-system:config": {
                    "openconfig-system:timezone-name": "EST -5 0"
                }
            },
```

It matches the "patch" that we made to the data for region2.

This is all done with the custom data filter `ciscops.mdd.mdd_combine` that is built off of the Ansible built-in `combine` filter. Using specific knowledge of the YANG data model, `ciscops.mdd.mdd_combine` is able to do context-aware patching of the data such that the intent of the patch is preserved in the resultant data model. It is invoked in the same way as the Ansible built-in `combine` filter:

```yaml
- name: Combine the MDD Data
  set_fact:
    mdd_data: "{{ mdd_data_list | ciscops.mdd.mdd_combine(recursive=True) }}"
```

This invocation of the `ciscops.mdd.mdd_combine` filter takes the default data and a list of patches and combines it recursively to produce one data structure where the patches later in the list take precedence over the data earlier in the list.

Now that you have seen how the data is constructed, in the next exercise you will expore how the data can be validated.

[Home](../README.md#workshop-exercises) | [Previous](explore-inventory.md#exploring-the-inventory) | [Next](data-validation.md#data-validation)