# Pushing Data

## Dependencies

See [Initial Setup](exercises/initial-setup.md)
See [Deploying the Topology](exercises/deploy-topology.md)

## Procedure

### Pushing Data

* Save the current NSO rolllback (optional)

```
ansible-playbook ciscops.mdd.nso_save_rollback
```

* Perform a dry run to see the proposed changed (optional)

```
ansible-playbook ciscops.mdd.nso_update_oc
```

* Push the data to the devices through NSO

```
ansible-playbook ciscops.mdd.nso_update_oc -e dry_run=no
```