# Initial Setup

This workshop is designed to work with Visual Studio Code and the Cisco NSO DevNet sandbox. Before you begin, please visit the DevNet sandbox [page](https://developer.cisco.com/site/sandbox/) and reserve the Cisco Network Services Orchestrator sandbox. Once your NSO sandbox has been provisioned, you can proceed with the steps below to get it setup for the rest of the workshop.  In this exercise you will:

- Connect to your sandbox via VPN
- Open Visual Studio Code and connect to the DevBox in the sandbox.
- Clone the MDD repo and set the required environment variables
- Install the required Python packages and Ansible collections

## Steps
1. Following the instructions in your NSO sandbox, connect to the sandbox via VPN.

1. If you don't already have it installed, install Visual Studio Code and the Remote - SSH plugin. Note: you can use any IDE you prefer, if you do not prefer to use Visual Studio Code. However, the instructions specified in this workshop will need to be modified for you environment.

1. Open Visual Studio Code and click the blue "Open a Remote Window" button in the bottom left corner then choose "Connect to Host...".  Select "+ Add New SSH Host..." from the list and enter the command to access the DevBox and then press return.
    ```
    ssh developer@10.10.20.50
    ```

1. Click the blue "Open a Remote Window" button in the bottom left corner, choose "Connect to Host..." and select 10.10.20.50 from the list.  When prompted, enter the DevBox password.

1. Click the "Clone Git Repository..." and clone the MDD repo URL.  When prompted, accept the default directory to clone the repo into (`/home/developer`)
    ```
    https://github.com/model-driven-devops/mdd.git
    ```

1. When prompted, click "Open" to open the MDD repo and enter the DevBox password.

1. Open a new terminal in Visual Studio Code using the Terminal menu (or CTRL-` if you like shortcuts). All future commands for this workshop should be executed in this terminal.

1. Checkout the "learning-lab" branch.
    ```
    git checkout learning-lab
    ```

1. Create a Python virtual envrironment and activate it.
    ```
    python3 -m venv venv
    source venv/bin/activate
    ```

1. Source the `envvars` file.
    ```
    source envvars
    ```

1. Install the required Python packages.
    ```
    pip install -r requirements.txt
    ```

1. Install the required Ansible collections.
    ```
    ansible-galaxy collection install -r requirements.yml
    ```

That's it! Your environment should be properly setup and you are ready to start your journey with Model-Driven DevOps.

[Home](../README.md#workshop-exercises) | [Previous](../README.md#workshop-exercises) | [Next](deploy-topology.md#deploying-the-topology)
