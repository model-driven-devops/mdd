# Initial Setup

This workshop is designed to work with Visual Studio Code and the Cisco NSO DevNet sandbox. You will be using a pre-provisioned DevNet NSO sandbox.  In this exercise you will:

- Connect to your sandbox via VPN
- Open Visual Studio Code and connect to the DevBox in the sandbox.

To get started, open a terminal and change into the `DEVWKS-2870/mdd` directory.

```
cd ~/workshop/DEVWKS-2870/mdd
```

Start the VPN and enter your VPN password.

```
./start-vpn.sh
```
If the VPN started correctly you should see the following in the output:

```
state: Connected
```

> Note: If the VPN fails to start, make sure you fix this before proceeding.

Open a remote session to the sandbox in Visual Studio Code.

```
code --folder-uri vscode-remote://ssh-remote+developer@10.10.20.50/home/developer/mdd-workshop
```

Enter the sandbox password `C1sco12345` when prompted.

> Note: if you get a key error with this command run `rm ~/.ssh/known_hosts` to clear out the SSH host cache.

Open a terminal in Visual Studio Code and activate the Python virtual environment.

```
source venv/bin/activate
source envvars
```
That's it! Your environment should be properly setup and you are ready to start your journey with Model-Driven DevOps.

[Home](../README.md#workshop-exercises) | [Previous](../README.md#workshop-exercises) | [Next](explore-inventory.md#exploring-the-inventory)
