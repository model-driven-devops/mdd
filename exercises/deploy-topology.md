# Deploying the Topology

## Dependencies

See [Initial Setup](exercises/initial-setup.md)

## Environment Variables

* `CML_HOST`: The hostname of the CML server
* `CML_USERNAME`: The username of the CM user.
* `CML_PASSWORD`: The password of the CML user.
* `CML_LAB`: The name of the lab
* `CML_VERIFY_CERT`: Whether to verify SSL Certificates

## Ansible Variables

* `cml_lab_file`: The CML topology file to to deploy (defined in `inventory/group_vars/all/cml.yml`)

## Procedure

### Deploying the CML Topology

```
ansible-playbook build-cml.yml
```

### Cleaning the CML Topology
```
ansible-playbook clean-cml.yml
```