# Initial Setup

## Depedancies
### Python 
```
python3 -m venv venv-mdd
. ./venv-mdd/bin/activate
pip3 install -r requirements.txt
```
### Ansible Collections
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
### Environment Variables
```
. ./envvars
```