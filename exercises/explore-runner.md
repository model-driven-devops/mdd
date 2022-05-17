# MDD: Exploring the Runner

A runner is used to execute a sequence of operations that achieve and overall task or workflow.  The MDD reference implementation uses [Github Actions](https://github.com/features/actions) as a runner for its CI/CD pipeline because it is integrated into the GitHub platform.  An Enterprise might choose other runners such as GitLab CI or Jenkins.  Since most runners operate fundamentally the same way, moving between runners is not difficult.  This reference implementation uses the same runner for both CI and CD.  This is by design since the only way to completely test the CD tooling is to use it for CI.  A feature of GitHub Actions that is also found in most other runners is the ability to start a workflow through an API.  This allows for higher-level applications such as ITSMs to start CI and CD workflows in order to fulfill a customer request.

As an example of a runner, let's consider a simple one that runs a command from a previous exercise:


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

This Github Actions checks out the repo and then runs the playbook `ciscops.mdd.show`.  The `on:` section defines this as an on-demand action (as opposed to being tied to another action or timed running) that can take input.  In this case, it can take in a list of hosts to limit the running of the playbook against that subset of hosts.  In the `jobs:` section, the type of node and the container in which to run the commands is defined.  By using a container, we can make sure that all of the tooling and its dependencies are available.  Finally, each individual command is specified under `steps:`. When run, the action simply executes each of these commands in order.  More information can be found in the [GitHub Action documentation](https://docs.github.com/en/actions).

In order to put this action into service, it is saved as `.github/workflows/show.yml` in the repository.  After this file is checked into the repo, the action will show under the Actions tab (assuming that you have Actions enabled):

![Workflow List](workflow-list.png?raw=true "Workflow List")

In order to run the workflow, pick the `Show` workflow from this list, select the branch, and modify `Limit Hosts` to suit intent:

![Run Workflow](run-workflow.png?raw=true "Run Workflow")

Afterwards, you should be able to click on the workflow job and get the output:

![Workflow Output](workflow-output.png?raw=true "Workflow Output")

