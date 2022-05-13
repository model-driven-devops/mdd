# Initial Setup

There are three ways to run the tooling in this repo:
1) Locally in the native OS
2) Using a container on top of your native OS
3) Using GitHub actions from a fork of the repo (covered later)

## Cloning the repo for local execution
### Clone the repo

First, clone and enter the repo:
```
git clone https://github.com/model-driven-devops/mdd.git
cd mdd
```

## Dependencies

* Environmental Variables
* Docker (if running in a docker container)

### Environmental Variables
The MDD tooling requires several environment variables.  The first one required for
base execution is:
```
export ANSIBLE_PYTHON_INTERPRETER=${VIRTUAL_ENV}/bin/python
```

You can define this variable from the `envars` file:

```
. ./envvars
```

### Docker

## Running Locally in the Native OS
### Python Dependancies
Next, it is highly recommended that you create a virtual environment to make it easier to
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
> Note: If you want to develop a collection, you need to set `ANSIBLE_COLLECTIONS_PATH` (or set in ansible.cfg)
before installing the requirements above to tell Ansible to look locally for collections, comment out the collection
in requirements.yml, and clone the collection repo directly, e.g.
```
export ANSIBLE_COLLECTIONS_PATH=./
cd ansible_colletions
mkdir ciscops
cd ciscops
git clone git@github.com:model-driven-devops/ansible-mdd.git mdd
```

## Running in a Container on top of your native OS
If you are running the tools from a CI runner like GitHib Actions, you'll need to consult that CI runner's
documentation for how to run tooling from a container.  Examples of how to run the tooling from a
container in GitHib actions can be found in `.github/workflows` in this repo.

*** Need to put more verbiage on running in the container (e.g. Where does it get the tooling, where does it get the data)

If you are running the tooling locally instide a container, you can use the provided shell script
`play.sh`.  To use it, replace `ansible-playbook` with `./play.sh` as follows:

```
./play.sh ciscops.mdd.show_oc --limit=hq-rtr1
```

> Note: The same applies as above to developing running in the container.

## Testing
At this point, you should be able to show the config data for the hosts in the inventory.
To show the config data for `hq-rtr1`, run:
```
ansible-playbook ciscops.mdd.show_oc --limit=hq-rtr1
```