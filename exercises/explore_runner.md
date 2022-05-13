# MDD: Exploring the Runner

A runner is used to execute a sequence of operations that acheive and overall task or workflow.  The MDD reference implimentation uses [Github Actions](https://github.com/features/actions) as a runner for it's CI/CD pipeline because it is integrated into the GitHub platform.  Enterpirses might chose other tunners such as GitLab CI or Jenkins.  Since most runners operate un fundmaentally the same way, moving between runners is not difficult.  This reference implementaion uses the same runner for both CI and CD.  This is buy design since the only way to completely test the CD tooling is to use it for CI.  As feature of GitHub Actions that is also found in most other runners is the abiltiy to start a workflow through an API.  This allowes for higher-level applcations such as ITSMs to start for CI and CD workflows in order to fullful a customer request.

As an example of a runner, let's consider a simple one that runs a command from a previous excercise:

```
---
name: Show
on:
  workflow_dispatch:
    inputs:
      limit:
        description: 'Limit Hosts'
        type: string 
        required: false
        default: 'all'

jobs:
  show:
    runs-on: ubuntu-20.04
    container:
      image: ghcr.io/model-driven-devops/mdd:latest
    steps:
      - name: Checkout Inventory
        uses: actions/checkout@v2
      - name: Show
        run: ansible-playbook ciscops.mdd.show --limit=${{ inputs.limit }}
```

This Github Actions checks out the repo and then runs the playbook `ciscops.mdd.show`.  It is an on demand action (as opposed to being tied to another action or timed running) that can take input.  In this case, it can take in a list of hosts to limit the running of the playbook against that subset of hosts.  In order to put this action into service, it is saved as `.github/workflows/show.yml` in the repository.