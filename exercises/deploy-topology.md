# Deploying the Topology


![MDD Reference Topology](mdd_topo.png?raw=true "MDD Reference Topology")


Stop the default topology in the sandbox, we will not be using it.  This command may take a minute or two to execute.

```
ansible-playbook cisco.cml.clean -e cml_lab='"Multi Platform Network"'
```

Clean up NSO.

```
ansible-playbook extras/clean_nso.yml
```

Build the MDD reference topology in CML and wait for the lab to boot.  This will take several minutes.  If you want to watch the topology come online, you can browse to CML at https://10.10.20.161 and login with your developer credentials to explore the topology while it boots.

```
ansible-playbook cisco.cml.build -e wait=yes
```

Configure the required auth group in NSO.
```
ansible-playbook ciscops.mdd.nso_init
```

Install the OpenConfig service on NSO.
```
ansible-playbook ciscops.mdd.nso_update_packages -e sudo_required=no -e remote_src=no
```

Update NSO with the devices in the MDD reference topology.  Note, if this command fails, you may need to re-run it.  This is an artifact of ARP cache issues in the sandbox and devices may not respond right away.
```
ansible-playbook ciscops.mdd.nso_update_devices
```

[Home](../README.md#workshop-exercises) | [Previous](initial-setup.md#initial-setup) | [Next](explore-inventory.md#exploring-the-inventory)