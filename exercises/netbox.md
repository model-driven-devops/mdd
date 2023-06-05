```
export NETBOX_API=http://devtools-netbox.lab.devnetsandbox.local/
export NETBOX_TOKEN=0123456789abcdef0123456789abcdef01234567
```

```
ansible-playbook ciscops.mdd.netbox_init
```

```
ansible-playbook ciscops.mdd.inventory_update_netbox
```

```
ansible-playbook ciscops.mdd.nso_update_netbox
```

```
find mdd-data -type f -name 'oc-interfaces.yml' -delete
```

```
cp files/oc-nat-interfaces.yml mdd-data/org/region1/hq/hq-pop
```

```
ansible-playbook extras/netbox_delete_interfaces.yml
```

```
ansible-playbook ciscops.mdd.update -e workers=1
```

```
ansible-playbook ciscops.mdd.update -e workers=1 -e dry_run=no
```

Run show playbook to view combined data.

```
ansible-playbook ciscops.mdd.show --limit hq-rtr1
```

Now go into NetBox and modify the IP address for site1-rtr1 interface GigabitEthernet3.10 from 192.168.1.0/24 to 192.168.100.0/24 and run the show playbook to see changed value.

```
ansible-playbook ciscops.mdd.show --limit site1-rtr1
```

Now run update with a dry run to see what would be changed

```
ansible-playbook ciscops.mdd.update -e workers=1
```

To stop using NetBox as a source of truth, unset the environtment variables.

```
unset NETBOX_API
unset NETBOX_TOKEN
```