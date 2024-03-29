# State Checking

The last step in the CI part of the MDD CI/CD pipeline is State Checking.  In the Data Validation step, we checked
the configuration data before it was pushed into the network.  State Checking is an important step because if verifies that a
change has the desired affect while not breaking anything else.  While we are covering State Checking in this
exercise as part of CI, it can be used in CD as well by design.  It is a core tenant of Model-Driven DevOps to use
the same code for testing as is used for deployment where possible.  In the case of State Checking, we use a test
network comprised of virtual devices where possible and physical devices where necessary.  Since we are using the actual OSs as the production network for the CI tests, we can run those same tests after CD in the production network or just to check state as part of a monitoring
framework.


![State Checking](overview-check-state.png?raw=true "State Checking")

## Defining the Checks

We define State Checks in the same way that we define Data Validation, by using files in `mdd-data` that apply by
where they are in the directory hierarchy.  In the case of State Checking, these files are prefixed with `check-`.
For example, the file `mdd-data/check-site-routes.yml` defines a check that verifies routes in a routing table:

```
---
mdd_tags:
  - hq_router
  - site_router
mdd_checks:
  - name: Check Network-wide Routes
    command: 'show ip route vrf internal_1'
    schema: 'pyats/show_ip_route.yml.j2'
    method: cli_parse
    check_vars:
      vrf: internal_1
      routes:
        - 172.16.0.0/24
        - 192.168.1.0/24
        - 192.168.2.0/24
```

Just like in the other definition files, we can specify the list of tags that are required on a device for this
test to be run against it.  When multiple tags are listed, the device just needs any one of the specified tags.
In this case, we are running the test on all devices that either have the tag `hq_router` or `site_router`.  The actual
test is defined under `mdd_data` and includes the following attributes:

* `name`: The name of the check
* `command`: The command run to gather the information for the check
* `schema`: The schema template to which to apply the structured data
* `method`: The method used to run and parse the data (e.g. `cli_parse` for direct or `nso_parse` to run through NSO)
* `check_vars`: Variables to be passed into the template.

By allowing the passing in of variables, the same schema can be used to check multiple different routers.

## Structured Data

We use JSON Schema for checking state, just like we did when we validated data, to avoid a programmatic approach that would
require writing a new script or playbook for each test.  Using JSON Schema for state validation is more modular and
requires little to no programming.

Using JSON Schema, however, does require structured data.  One option for structured data is to use the API provided by
the device itself.  Many modern devices provide a structured API that provides operational data.  The problem is that
they generally use different models between devices and vendors, requiring different JSON Schemas which adds more work
and creates more code to maintain.  Another option is it take the unstructured data from "show" commands and structure
it in a consistent way.  Using the CLI also has the advantage of supporting legacy devices;
however, the composition of your network might drive a different set of decisions.

In the case of this reference implementation, we use [pyATS](https://pubhub.devnetcloud.com/media/pyats/docs/overview/index.html)
to parse the unstructured data into structured data.  Specifically, we use the parsers from pyATS (as opposed to its test automation framework) either through NSO or
direct to device using the `ansible.netcommon.cli_parse` module.  If we run the `ciscops.mdd.check` in debug (i.e. `-vvv`)
for `site1-rtr1` we get the following parsed output from a `show ip route` command:

```
# ansible-playbook ciscops.mdd.check --limit=site1-rtr1 -vvv
```
[...]
```
ok: [site1-rtr1] => {
    "ansible_facts": {
        "parsed_output": {
            "vrf": {
                "internal_1": {
                    "address_family": {
                        "ipv4": {
                            "routes": {
                                "172.16.0.0/24": {
                                    "active": true,
                                    "metric": 0,
                                    "next_hop": {
                                        "next_hop_list": {
                                            "1": {
                                                "index": 1,
                                                "next_hop": "10.255.255.11",
                                                "updated": "00:05:58"
                                            }
                                        }
                                    },
                                    "route": "172.16.0.0/24",
                                    "route_preference": 200,
                                    "source_protocol": "bgp",
                                    "source_protocol_codes": "B"
                                },
                                "172.16.255.1/32": {
                                    "active": true,
                                    "metric": 0,
                                    "next_hop": {
                                        "next_hop_list": {
                                            "1": {
                                                "index": 1,
                                                "next_hop": "10.255.255.11",
                                                "updated": "00:05:58"
                                            }
                                        }
                                    },
                                    "route": "172.16.255.1/32",
                                    "route_preference": 200,
                                    "source_protocol": "bgp",
                                    "source_protocol_codes": "B"
                                },
                                "172.16.255.2/32": {
                                    "active": true,
                                    "metric": 0,
                                    "next_hop": {
                                        "next_hop_list": {
                                            "1": {
                                                "index": 1,
                                                "next_hop": "10.255.255.12",
                                                "updated": "00:05:58"
                                            }
                                        }
                                    },
                                    "route": "172.16.255.2/32",
                                    "route_preference": 200,
                                    "source_protocol": "bgp",
                                    "source_protocol_codes": "B"
                                },
                                "192.168.1.0/24": {
                                    "active": true,
                                    "next_hop": {
                                        "outgoing_interface": {
                                            "GigabitEthernet2.10": {
                                                "outgoing_interface": "GigabitEthernet2.10"
                                            }
                                        }
                                    },
                                    "route": "192.168.1.0/24",
                                    "source_protocol": "connected",
                                    "source_protocol_codes": "C"
                                },
                                "192.168.1.1/32": {
                                    "active": true,
                                    "next_hop": {
                                        "outgoing_interface": {
                                            "GigabitEthernet2.10": {
                                                "outgoing_interface": "GigabitEthernet2.10"
                                            }
                                        }
                                    },
                                    "route": "192.168.1.1/32",
                                    "source_protocol": "local",
                                    "source_protocol_codes": "L"
                                },
                                "192.168.2.0/24": {
                                    "active": true,
                                    "metric": 0,
                                    "next_hop": {
                                        "next_hop_list": {
                                            "1": {
                                                "index": 1,
                                                "next_hop": "10.255.255.14",
                                                "updated": "00:05:58"
                                            }
                                        }
                                    },
                                    "route": "192.168.2.0/24",
                                    "route_preference": 200,
                                    "source_protocol": "bgp",
                                    "source_protocol_codes": "B"
                                },
                                "192.168.255.1/32": {
                                    "active": true,
                                    "next_hop": {
                                        "outgoing_interface": {
                                            "Loopback0": {
                                                "outgoing_interface": "Loopback0"
                                            }
                                        }
                                    },
                                    "route": "192.168.255.1/32",
                                    "source_protocol": "connected",
                                    "source_protocol_codes": "C"
                                },
                                "192.168.255.2/32": {
                                    "active": true,
                                    "metric": 0,
                                    "next_hop": {
                                        "next_hop_list": {
                                            "1": {
                                                "index": 1,
                                                "next_hop": "10.255.255.14",
                                                "updated": "00:05:58"
                                            }
                                        }
                                    },
                                    "route": "192.168.255.2/32",
                                    "route_preference": 200,
                                    "source_protocol": "bgp",
                                    "source_protocol_codes": "B"
                                }
                            }
                        }
                    }
                }
            }
        }
    },
    "changed": false
}
```

As you can see, what was previously unstructured CLI output is now nicely structured data that can be verified
with a JSON Schema.  

## Schema

Now that we have structured data representing the state of the device, we can construct a JSON Schema to check to
make sure that it is at the desired state.  For this topology, we want to check that the routes for the HQ and other
sites appear in each of the sites.  In some circumstances, these routes can vary depending on the location in the network.  To keep
us from needing to write a different schema for each check, we construct the JSON Schema as a Jinja template:

```
type: object
properties:
  required:
    - vrf
  vrf:
    type: object
    properties:
      required:
        - {{ check_vars.vrf }}
      {{ check_vars.vrf }}:
        type: object
        properties:
          required:
            - address_family
          address_family:
            type: object
            properties:
              required:
                - ipv4
              ipv4:
                type: object
                required:
                  - routes
                properties:
                  routes:
                    type: object
                    required: {{ check_vars.routes }}
```

As with the schemas used for data validation, it follows the structure of the data.  At the places in the
data structure where the values would change for a particular check, we use Jinja to inject the correct
values.  These values are retrieved from the check definition file as provided by the `check_vars` attribute.
In the case of this particular check, `{{ check_vars.vrf }}` is replaced with `internal_1` and `{{ check_vars.routes }}`
is replaced with:

```
        - 172.16.0.0/24
        - 192.168.1.0/24
        - 192.168.2.0/24
```

This templating, in combination with the ability to place different checks in different parts of the network
hierarchy, provides us with the ability to check for different subnets in different places.


## Running the Checks

The playbook `ciscops.mdd.check` is used to run the checks.  Let's look at how it operates by walking
through a truncated version of the output when run against a single device:


```
root@35b465b753a2:/workspaces/mdd# ansible-playbook ciscops.mdd.check --limit=hq-rtr1
```

First, the playbook looks for all the check definition files that apply to the devices in scope, then checks
that list against the tags in the definition:

```

TASK [Search for check files] *************************************************************************************

TASK [ciscops.mdd.common : Find MDD data files in the directory] **************************************************
ok: [hq-rtr1]

TASK [ciscops.mdd.check : Read in check files] ********************************************************************
ok: [hq-rtr1] => (item=/workspaces/mdd/mdd-data/org/check-bgp-neighbor-status.yml)
ok: [hq-rtr1] => (item=/workspaces/mdd/mdd-data/org/check-site-routes.yml)

TASK [ciscops.mdd.check : Find relevant checks] *******************************************************************
ok: [hq-rtr1] => (item={'mdd_tags': ['hq_router', 'site_router'], 'mdd_checks': [{'name': 'BGP VPNV4 Neighbor Status', 'command': 'show ip bgp vpnv4 all neighbors', 'schema': 'pyats/bgp-neighbor-state.yml', 'method': 'cli_parse'}]})
ok: [hq-rtr1] => (item={'mdd_tags': ['hq_router', 'site_router'], 'mdd_checks': [{'name': 'Check Network-wide Routes', 'command': 'show ip route vrf internal_1', 'schema': 'pyats/show_ip_route.yml.j2', 'method': 'cli_parse', 'check_vars': {'vrf': 'internal_1', 'routes': ['172.16.0.0/24', '192.168.1.0/24', '192.168.2.0/24']}}]})
```

Then it runs the actual checks.  While the devices are run in parallel as specified in the Ansible configuration
(Usually five at a time), the checks for a particular device are run sequentially:

```
TASK [Run Checks] *************************************************************************************************

TASK [Run command show ip bgp vpnv4 all neighbors] ****************************************************************
[WARNING]: ansible-pylibssh not installed, falling back to paramiko

TASK [ciscops.mdd.check : Get the output via cli_parse and PyATS] *************************************************
ok: [hq-rtr1]

TASK [ciscops.mdd.check : Check data against the schema] **********************************************************
ok: [hq-rtr1]

TASK [Run command show ip route vrf internal_1] *******************************************************************

TASK [ciscops.mdd.check : Get the output via cli_parse and PyATS] *************************************************
ok: [hq-rtr1]


TASK [ciscops.mdd.check : Check data against the schema] **********************************************************
ok: [hq-rtr1]

PLAY RECAP ********************************************************************************************************
hq-rtr1                    : ok=14   changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0   
```

At this point, the check step is finishes, and all the checks have passed.  Let's look at what happens when
something fails.  If we simply add a network to the check definition that we know we are not pushing out, we should
see that fail:

```
---
mdd_tags:
  - hq_router
  - site_router
mdd_checks:
  - name: Check Network-wide Routes
    command: 'show ip route vrf internal_1'
    schema: 'pyats/show_ip_route.yml.j2'
    method: cli_parse
    check_vars:
      vrf: internal_1
      routes:
        - 172.16.0.0/24
        - 192.168.1.0/24
        - 192.168.2.0/24
        - 192.168.3.0/24
```

When we run the check again, we see:

```

TASK [ciscops.mdd.check : Check data against the schema] **********************************************************
fatal: [hq-rtr1]: FAILED! => {"changed": false, "failed_schema": "<input>", "msg": "Schema Failed: $.vrf.internal_1.address_family.ipv4.routes: '192.168.3.0/24' is a required property", "x_error_list": ["$.vrf.internal_1.address_family.ipv4.routes: '192.168.3.0/24' is a required property"]}

TASK [ciscops.mdd.check : set_fact] *********************************************************************
ok: [hq-rtr1]

TASK [debug] ******************************************************************************************************
fatal: [hq-rtr1]: FAILED! => {
    "failed_checks": [
        "Check Network-wide Routes"
    ],
    "failed_when_result": true
}

PLAY RECAP ********************************************************************************************************
hq-rtr1                    : ok=14   changed=0    unreachable=0    failed=1    skipped=3    rescued=1    ignored=0   
```
