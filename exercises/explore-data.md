# MDD: Exploring the Data
Although we also leverage the Ansible inventory, we use a separate directory heiracrhy to hold the MDD data named `mdd-data` (this can be changed in the defaults).  This is because the large about of data necessary to configure modern networks would be difficult to manage with the way the Ansible inventory system works.  This method allows the tool to read just the data that is needed into the device's context and for that data to be organized in a determinisitc heriarchy.  The data is layed out in the directory as follows:

```
mdd-data
└── org
    ├── region1
    │   ├── hq
    │   │   ├── hq-rtr1
    │   │   ├── hq-rtr2
    │   │   ├── hq-sw1
    │   │   └── hq-sw2
    │   └── site1
    │       ├── site1-rtr1
    │       └── site1-sw1
    └── region2
        └── site2
            ├── site2-rtr1
            └── site2-sw1
```

This aligns with the way that the devices are organizaed in the Ansible inventory:

```
@all:
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
```

Data at the deeper levels of the tree (closer to the device) take precendense over data closer to the root of the tree.  Each of the files in the heiracrhy are named by for the purpose and content.  For OpenConfig data, the filenames begin with `oc-`, but this is configurable.  For example, the file `mdd-data/org/oc-ntp.yml` contains the organization level NTP configuration:

```
---
mdd_data:
  openconfig-system:system:
    openconfig-system:clock:
      config:
        timezone-name: 'PST -8 0'
    openconfig-system:ntp:
      config:
        enabled: true
      servers:
        server:
          - address: '1.us.pool.ntp.org'
            config:
              address: '1.us.pool.ntp.org'
              association-type: SERVER
              iburst: true
          - address: '2.us.pool.ntp.org'
            config:
              address: '2.us.pool.ntp.org'
              association-type: SERVER
              iburst: true
```

The OpenConfig data is collected under the `mdd_data` key.  While this file just includes the OC data to define NTP, it will later be combined with the rest of the OC data to create the full data payload.  Since this data is at the root of the heirachrcy, it can be overridden by anything else closer to the device.  If we want to set `timezone-name` to something specific to a particular region, we can override it at the region level.  For example, `mdd-data/org/region2/oc-ntp.yml` could contain:

```
---
mdd_data:
  openconfig-system:system:
    openconfig-system:clock:
      config:
        timezone-name: 'EST -5 0'
```

This file only contains the data needed to override specific values and the approriate structure to place it in context of the overall data model.

To see the effect this has on the data run the following:

```
ansible-playbook ciscops.mdd.show --limit=site1-rtr1
```

And compare to:

```
ansible-playbook ciscops.mdd.show --limit=site2-rtr1
```

In partucular, note the timezone set for `site1-rtr1`:
```
            "openconfig-system:clock": {
                "config": {
                    "timezone-name": "PST -8 0"
                }
            },
```

Compared to the timezone set for `site2-rtr1`:
```
            "openconfig-system:clock": {
                "config": {
                    "timezone-name": "EST -5 0"
                }
            },
```

It matches the "patch" that we made to the data for region2.