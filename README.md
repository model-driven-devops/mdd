# Model-Driven DevOps
This is a reference implementation for Model-Driven Devops as outlined in the book "Model-Driven DevOps: Increasing agility and security in your physical network through DevOps".  While the book capture the reference implementation at a moment in time, this reference implementation will evolve while holding true to the core concepts presented in the book.

## What is Model-Driven DevOps?
Model-Driven Devops (MDD) is an IaC approach to automating physical infrastrcuture that focuses on data organization and movement into the network in a way that seeks to treat the network the same as other parts of the infrastructure.  It focuses on using industry stanadrd tools and DevOps methodologies implemented as a CI/CD pipeline to break down silos between network operations and the rest of the infrastructure.  For example, this is a common flow in Cloud Operations:

![Cloud Ops Flow](exercises/cloud_ops_flow.png?raw=true "Cloud Ops Flow")

Key to this flow is that all of the data (Source of Truth) needed to configure the infrastructure is in the data file (CFT Template).  Also, this is not a programatic approach.  If you want to configure something different, you add data to the Source of Truth as opposed to writing another Ansible playbook or python script.  We firmily beleive that most network operators should not need to become programmers; however, they will have to learn a new skillset including APIs, data models, and data manipulation.

When fully implemented, MDD requires a similar skillset to cloud operations.  That is, when a network operator wants to configure, validate, or test something new, they just need to know how to add data to the Source of Truth and manipulate schemas.  Furthermore, MDD can fit into exsiting CI/CD pipelines as opposed to needing to operate the network infrastucture differently.  This allows for a de-siloization of IT making it possible to leverage developers and DevOps Engineers across application development, cloud operations, and network operations.  This is because the MDD pipeline looks the same as any other code (or IaC) pipeline:

![MDD Branch Flow](exercises/mdd_branching.png?raw=true "MDD Branch Flow")

This workflow allowed for a group of network engineers and network operators to collaborate on a change, test that change, get approvals, then push that change into the production network.  MDD includes comprehensive testing including linting the configuration data for typos, validating the configuration data for anything that would violate organization norms or create vulnerabilities, and then testing the result of that change in a network before deployment:

![MDD CI Flow](exercises/mdd_ci_flow.png?raw=true "MDD CI Flow")


## MDD Reference implementation

![MDD Reference Topology](exercises/mdd_topo.png?raw=true "MDD Reference Topology")


## Exercises
* [Initial Setup](exercises/initial-setup.md)
* [Deploying the Topology](exercises/deploy-topology.md)
* [Exploring the Inventory](exercises/explore-inventory.md)
* [Exploring the Data](exercises/explore-data.md)
* Exercising the Runner
* Data Validation
* Pushing the Data
* State Checking
