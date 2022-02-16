# Initial Setup

There are two ways to run the tooling in this repo:
1) Locally from a clone of the repo
2) Using GitHub actions from a fork of the repo

## Cloning the repo for local execution
### Clone the repo

First, clone and enter the repo:
```
git clone https://github.com/model-driven-devops/mdd.git
cd mdd
```

## Dependencies
The first step is to install the dependencies.  There are two sets of dependencies, Python and Ansible

### Python Dependancies
Next, tt is highly recommended that you create a virtual environment to make it easier to
install the dependencies without conflict:

```
python3 -m venv venv-mdd
. ./venv-mdd/bin/activate
```

Next, install the Python requirements via pip:
```
pip3 install -r requirements.txt
```

### Ansible Collections
The MDD tooling is distributed via an Ansible Collection.  To install the tooling and it's
Ansible dependencies, use ansible-galaxy:

```
ansible-galaxy collection install -r requirements.yml
```
> Note: If you want to develop a collection, you need to comment out the collection in requirements.yml and clone the collection repo directly, e.g.
```
cd ansible_colletions
mkdir ciscops
cd ciscops
git clone git@github.com:model-driven-devops/ansible-mdd.git mdd
```

## Environment Variables
Lastly, the MDD tooling requires several environment variables.  The first one required for
base execution is:
```
export ANSIBLE_PYTHON_INTERPRETER=${VIRTUAL_ENV}/bin/python
```

You can define this variable from the `envars` file:

```
. ./envvars
```

## Testing
At this point, you should be able to show the config data for the hosts in the inventory.
To show the config data for `hq-rtr1`, run:
```
ansible-playbook ciscops.mdd.show_oc --limit=hq-rtr1
```