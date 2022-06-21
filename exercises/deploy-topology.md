# Deploying the Topology

## Dependencies

See [Initial Setup](exercises/initial-setup.md)

## Topology

![MDD Reference Topology](mdd_topo.png?raw=true "MDD Reference Topology")

## Environment Variables

* `CML_HOST`: The hostname of the CML server
* `CML_USERNAME`: The username of the CM user.
* `CML_PASSWORD`: The password of the CML user.
* `CML_LAB`: The name of the lab
* `CML_VERIFY_CERT`: Whether to verify SSL Certificates

## Ansible Variables

* `cml_lab_file`: The CML topology file to deploy (defined in `inventory/group_vars/all/cml.yml`)
* `nso_installer_file`: URL to the NSO installer file
* `nso_ned_files`: List of URLs to the NSO NED files

## Procedure

### CML

#### Build the CML Topology

* Create the topology

```
ansible-playbook cisco.cml.build -e startup='host' -e wait='yes'
```

#### Cleaning the CML Topology (optional)

* Stop each node and delete the topology

```
ansible-playbook cisco.cml.clean
```

#### Getting Inventory (optional)

* Display the current inventory of CML devices

```
ansible-playbook cisco.cml.inventory
```

### NSO

#### Install NSO Software

* Install NSO in server mode

```
ansible-playbook ciscops.mdd.nso_install
```

#### Installing NSO Packages

* Install NSO MDD Packages

```
ansible-playbook ciscops.mdd.nso_update_packages
```

#### Inititalize NSO

* Add default Auth Group

```
ansible-playbook ciscops.mdd.nso_init
```

#### Adding CML Devices to NSO

* Add devices from inventory into NSO

```
ansible-playbook ciscops.mdd.nso_update_devices
```

>Note: Can be run with `--limit=<host>` to limit the scope of the playbook

#### Update NSO config from device (optional)

* Re-sync configuration from the device

```
ansible-playbook ciscops.mdd.nso_sync_from
```

>Note: Can be run with `--limit=<host>` to limit the scope of the playbook

#### Update device config from NSO (optional)

* Re-sync configuration to the device

```
ansible-playbook ciscops.mdd.nso_sync_to
```

>Note: Can be run with `--limit=<host>` to limit the scope of the playbook


#### Check to make sure device is in sync with NSO (optional)

* Re-sync configuration from the device

```
ansible-playbook ciscops.mdd.nso_check_sync
```

>Note: Can be run with `--limit=<host>` to limit the scope of the playbook