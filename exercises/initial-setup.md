# Initial Setup

This workshop requires access to a running network simulation and other resources in order to properly exercise the MDD reference architecture.  In this exercise you will:

- Open the MDD folder in Visual Studio Code
- Set the required environment variables
- Start the VPN required for accesss to the resources

To get started, open a terminal and start Visual Studio Code in the MDD directory:
```
code ~/DEVWKS-2870/mdd
```

Open a new terminal in Visual Studio Code using the Terminal menu (or CTRL-` if you like shortcuts). All future commands for this workshop should be executed in this terminal.

Enable the python virtual environment.

```
source venv/bin/activate
```

In the new terminal, source the `envvars` file.

```
source envvars
```

Then connect to the VPN.

```
./start-vpn.sh
```

If the VPN started correctly you should see the following in the output:

```
Session authentication will expire at ...
```

If the VPN fails to start, make sure you fix this before proceeding.

That's it! Your environment should be properly setup and you are ready to start your journey with Model-Driven DevOps.

[Home](../README.md#workshop-exercises) | [Previous](../README.md#workshop-exercises) | [Next](explore-inventory.md#exploring-the-inventory)