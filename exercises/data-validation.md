# Data Validation

Validating the data that we use to configure the devices before we send it to the device is one method used to find and fix issues before they negatively affect the network. It is a key part of the CI pipeline. There are two type of data validation done in this reference implementation:

1) Format Linting: Checking the syntax of the YAML used to represent the data
2) Data Validation: Making sure that the right data is present and correct

![Data Validation](overview-data-validation.png?raw=true "Data Validation")

## Format Linting

We use [`yamllint`](https://github.com/adrienverge/yamllint) to validate that the data is properly formatted in YAML. `yamllint` behavior is configured in the file `.yamllint.yml`. In order to run `yamllint` against the mdd data, we run:

```
yamllint mdd-data
```

This can be done manually or as part of the CI portion of the pipeline in the Github action. When there are no issues, `yamllint` will return silently with no error value. When it does find an issue, it will print out the finding with a non-zero return value. When the runner sees this non-zero return value indicating an error, the pipeline will fail and the findings presented in the test output. For example, let's break the formatting of the `mdd-data/org/oc-ntp.yml` file and see if the linter catches it.

Open the `mdd-data/org/oc-ntp.yml` file in the Visual Studio Code editor and indent line 14 two spaces to the right. The configuration for server 216.239.35.0 should look like:

```yaml
          - openconfig-system:address: '216.239.35.0'
            openconfig-system:config:
                openconfig-system:address: '216.239.35.0'
              openconfig-system:association-type: SERVER
              openconfig-system:iburst: true
```

Now when we run `yamllint` we get an error:

```
$ yamllint mdd-data
mdd-data/org/oc-ntp.yml
  14:17     error    wrong indentation: expected 14 but found 16  (indentation)
  15:15     error    syntax error: expected <block end>, but found '<block mapping start>' (syntax)
```

YAML requires consistent indentation (unlike JSON), therefore this file now fails during linting. Fix the indentation problem and re-run `yamllint` to make sure you do not have any linting errors:

```
yamllint mdd-data
```

## Data Validation

While linting makes sure that our data is structurally righteous, validation checks the righteousness of its intent.  For example, we can check to make sure that banners are configured and even verify their content, we can make sure that the right options are enabled to properly secure the platform, and we can make sure that our interfaces use IP addresses in the proper range.

We do these things using [JSON Schemas](https://json-schema.org). To recap, we are representing data described by an OpenConfig YANG data model using YAML.  We are then taking a JSON schema that is also rendered in YAML, to validate the data. While it might seem a bit of a contortion switching between different data model description and representation languages, the intent is to strike the best balances between humans understanding and generating the data and computers being able to consume it. In our case, the OpenConfig data model has already been defined in YANG and we do not have to modify it. Furthermore, JSON Schemas (even represented in YAML) are more widely used and better understood by most humans.  So while there is a bit of changing between formats, it should help with approachability. However, you can always choose to describe and render the data in whatever manner best fits your organization since these choices are orthogonal to the overall process.

### JSON Schema

Let's start by looking at a simple JSON schema to validate our banners. We define the banners in ```mdd-data/org/oc-banner.yml```:

```yaml
---
mdd_data:
  openconfig-system:system:
    openconfig-system:config:
      login-banner: "Unauthorized access is prohibited!"
      motd-banner: "Welcome to {{ inventory_hostname }}"
```

As mentioned in previous exercises, this data is merged in with the rest of the data that is collected on a per-device basis. Since it is at the org level it can be overridden by data at a more specific level. We do not define tags in this example, but we could also provide a tag to specify which devices this data applies to. While it is a simple banner definition, we want to 1) make sure that it is there and 2) make sure that it contains the word `prohibited` since it turns out that lawyers find words important.

The schema used to validate this data is in ```schemas/local/banner.schema.yml```:

```yaml
title: Network banner schema
type: object
required:
  - 'openconfig-system:system'
properties:
  'openconfig-system:system':
    type: object
    required:
      - 'openconfig-system:config'
    properties:
      'openconfig-system:config':
        type: object
        required:
          - login-banner
        properties:
          login-banner:
            type: string
            description: Login banner
            pattern: prohibited
```

And we configure the validation in ```mdd-data/org/validate-local.yml```:

```yaml
---
mdd_tags:
  - all
mdd_schemas:
  - name: banner
    file: 'local/banner.schema.yml'
  - name: dns
    file: 'local/dns.schema.yml'
```

This file tells the ciscops.mdd.validate role to apply the two schemas ```local/banner.schema.yml``` and ```local/dns.schema.yml``` to all devices at the org level of the hierarchy. The schemas are checked against the data after all the data for a particular device has been rendered. The validate action is done using the `ciscops.mdd.validate` role and called at the beginning of a playbook:

```yaml
- hosts: network
  connection: local
  gather_facts: no
  ignore_errors: yes
  roles:
    - ciscops.mdd.data      # Loads the OC Data
    - ciscops.mdd.validate  # Validates the OC Data
```

When executed in this way, the `ciscops.mdd.data` role generates the device-specific data payload, then the `ciscops.mdd.validate` role validates that data. The subsequent tasks will then operate on data that is known to be valid.

The playbook `ciscops.mdd.validate` is available in the `ciscops.mdd` collection and is used for the validation step of the CI pipeline. It can be run as follows:

```
ansible-playbook ciscops.mdd.validate
```

This playbook will produce a large amount of output when run against all devices. You should see the following truncated validation report near the end:

```
TASK [ciscops.mdd.validate : debug] ******************************************************************************************************************
ok: [hq-sw1] => {
    "validation_report": {
        "consolidated_report": {
            "failures": null,
            "passed": [
                "hq-pop",
                "hq-rtr1",
                "hq-rtr2",
                "hq-sw1",
                "hq-sw2",
                "site1-rtr1",
                "site1-sw1",
                "site2-rtr1",
                "site2-sw1",
                "WAN-rtr1"
            ]
        }
    }
}

PLAY RECAP *******************************************************************************************************************************************
WAN-rtr1                   : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
hq-pop                     : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
hq-rtr1                    : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
hq-rtr2                    : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
hq-sw1                     : ok=16   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
hq-sw2                     : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
site1-rtr1                 : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
site1-sw1                  : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
site2-rtr1                 : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
site2-sw1                  : ok=14   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
```

Notice there were no failures and all hosts passed.  Now let's test it.  Open the file ```mdd-data/org/oc-banner.yml``` and change the value of ```login-banner``` to ```Unauthorized access is strongly discouraged!```. When you are done, the data should look like this:

```yaml
---
mdd_data:
  openconfig-system:system:
    openconfig-system:config:
      openconfig-system:login-banner: "Unauthorized access is strongly discouraged!"
      openconfig-system:motd-banner: "Welcome to {{ inventory_hostname }}"
```

Now run the validate playbook again (for efficeincy we only run it on one device)

```
ansible-playbook ciscops.mdd.validate --limit site2-rtr1
```

And you should get the following truncated output:

```
TASK [ciscops.mdd.validate : debug] ******************************************************************************
ok: [site2-rtr1] => {
    "validation_report": {
        "consolidated_report": {
            "failures": [
                {
                    "hosts": "['site2-rtr1']",
                    "schemas": "['banner.schema.yml']"
                }
            ],
            "passed": []
        }
    }
}

TASK [fail] ******************************************************************************************************
fatal: [site2-rtr1]: FAILED! => {"changed": false, "msg": "Failed Validation"}

PLAY RECAP *******************************************************************************************************
site2-rtr1                 : ok=18   changed=0    unreachable=0    failed=1    skipped=1    rescued=0    ignored=2   
```

In this example, we see that the playbook failed for the device site2-rtr1, so that would also cause our CI to fail. We also see in the consolidated report that site2-rtr1 failed because of the schema `banner.schema.yml`. If we look up in the output a bit more, we see:

```
failed: [site2-rtr1] (item={'name': 'banner', 'file': 'local/banner.schema.yml'}) => {"ansible_loop_var": "mdd_schema_item", "changed": false, "failed_schema": "banner.schema.yml", "mdd_schema_item": {"file": "local/banner.schema.yml", "name": "banner"}, "msg": "Schema Failed: $.openconfig-system:system.openconfig-system:config.login-banner: 'Unauthorized access is strongly discouraged!' does not match 'prohibited'", "x_error_list": ["$.openconfig-system:system.openconfig-system:config.login-banner: 'Unauthorized access is strongly discouraged!' does not match 'prohibited'"]}
```

This tells us exactly what failed. Apparently, our warning was not strong enough. Replace the contents of ```mdd-data/org/oc-banner.yml``` with the original data:

```yaml
---
mdd_data:
  openconfig-system:system:
    openconfig-system:config:
      openconfig-system:login-banner: "Unauthorized access is prohibited!"
      openconfig-system:motd-banner: "Welcome to {{ inventory_hostname }}"
```

And rerun the validate playbook to verify that your login banner is valid:

```
ansible-playbook ciscops.mdd.validate --limit site2-rtr1
```

You can do this same exercise with DNS servers. Change the DNS servers used in region1 by creating the file `mdd-data/org/region1/oc-dns.yml`.

```
cp files/oc-dns.yml mdd-data/org/region1/oc-dns.yml
```

This file contains the following data. View the file in the editor to verify.

```yaml
---
mdd_data:
  openconfig-system:system:
    openconfig-system:dns:
      openconfig-system:servers:
        openconfig-system:server:
          - openconfig-system:address: 208.67.222.222
            openconfig-system:config:
              openconfig-system:address: 208.67.222.222
              openconfig-system:port: 53  # always 53 for ios
          - openconfig-system:address: 8.8.8.8
            openconfig-system:config:
              openconfig-system:address: 8.8.8.8
              openconfig-system:port: 53  # always 53 for ios
```

Then run the validation for `hq-rtr1` (which is in region1):

```
ansible-playbook ciscops.mdd.validate --limit hq-rtr1
```

We get the following truncated output:

```
TASK [ciscops.mdd.validate : debug] ******************************************************************************
ok: [hq-rtr1] => {
    "validation_report": {
        "consolidated_report": {
            "failures": [
                {
                    "hosts": "['hq-rtr1']",
                    "schemas": "['dns.schema.yml']"
                }
            ],
            "passed": []
        }
    }
}

TASK [fail] ******************************************************************************************************
fatal: [hq-rtr1]: FAILED! => {"changed": false, "msg": "Failed Validation"}

PLAY RECAP *******************************************************************************************************
hq-rtr1                    : ok=18   changed=0    unreachable=0    failed=1    skipped=1    rescued=0    ignored=2   
```

Since we put `oc-dns.yml` at the region1 level, it applied to all of the devices in region1 causing them to fail data validation. That is because we specified a DNS server that is not listed in the schema `schemas/local/dns.schema.yml` which specifies that the DNS server address should be one of an enumeration:

```yaml
                    config:
                      description: configuration
                      type: object
                      properties:
                        address:
                          description: DNS server address
                          type: string
                          format: ipv4
                          enum:
                            - 208.67.222.222
                            - 208.67.220.220
```

We could potentially address this is in a couple of different ways:
1. If we wanted to allow `8.8.8.8` to be used accross the organization, we could add it to the enumeration in `schemas/local/dns.schema.yml`.
2. We could define different schemas for different regions (e.g. `mdd-data/org/region1/validate-dns.yml` and `mdd-data/org/region2/validate-dns.yml`) that specify different schemas to use to validate data for the devices in each of those regions.

For now, just remove the the `mdd-data/org/region1/oc-dns.yml` file:

```
rm mdd-data/org/region1/oc-dns.yml
```

And rerun the validate playbook and verify that your DNS configuration is valid again:

```
ansible-playbook ciscops.mdd.validate --limit hq-rtr1
```

Now that you know your data is valid, it is time to do something with it.  In the next exercise you will learn the various ways that you can push your data into the network.

[Home](../README.md#workshop-exercises) | [Previous](explore-data.md#exploring-the-data) | [Next](push-data.md#pushing-data)