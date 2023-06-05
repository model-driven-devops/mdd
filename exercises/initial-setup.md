# Initial Setup

This workshop is designed to work with Visual Studio Code and the Cisco NSO DevNet sandbox. You will be using a pre-provisioned DevNet NSO sandbox.  In this exercise you will:

- Connect to your sandbox via VPN
- Open Visual Studio Code and connect to the DevBox in the sandbox.

To get started, open a terminal and change into the `DEVWKS-2870/mdd` directory.

```
cd ~/DEVWKS-2870/mdd
```

Set an environment variable for your sandbox VPN password (substitute your password here).

```
export VPN_PASSWORD=your_vpn_password
```

Start the VPN.

```
./start-vpn.sh
```
If the VPN started correctly you should see the following in the output:

```
Session authentication will expire at ...
```

> Note: If the VPN fails to start, make sure you fix this before proceeding.

Open a remote session to the sandbox in Visual Studio Code.

```
code --folder-uri vscode-remote://ssh-remote+10.10.20.50/home/developer/mdd
```

Enter the sandbox password `C1sco12345` when prompted.

That's it! Your environment should be properly setup and you are ready to start your journey with Model-Driven DevOps.

[Home](../README.md#workshop-exercises) | [Previous](../README.md#workshop-exercises) | [Next](explore-inventory.md#exploring-the-inventory)
