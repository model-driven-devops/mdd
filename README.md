# Model-Driven DevOps

<img align="right" width="300" height="400" src="exercises/MDD-Book-Cover.png">

## What is Model-Driven DevOps?
Model-Driven Devops (MDD), as outlined in the book ["Model-Driven DevOps: Increasing agility and security in your physical network through DevOps"](https://www.informit.com/store/model-driven-devops-increasing-agility-and-security-9780137644674)
([Amazon](https://www.amazon.com/Model-driven-Devops-Increasing-Security-Physical/dp/0137644671/ref=sr_1_1?crid=1X8MTIAXRKLMI&keywords=model-driven+devops&qid=1650992113&sprefix=model-driven+devop%2Caps%2C202&sr=8-1)), is an IaC approach to automating physical infrastructure that focuses on data organization and movement into the network in a way that seeks to treat the network the same as other parts of the infrastructure.  It focuses on using industry standard tools and DevOps methodologies implemented as a CI/CD pipeline to break down silos between network operations and the rest of the infrastructure.  For example, this is a common flow in Cloud Operations:

![Cloud Ops Flow](exercises/cloud_ops_flow.png?raw=true "Cloud Ops Flow")

Key to this flow is that all of the data (Source of Truth) needed to configure the infrastructure is in the data file (CFT Template).  Also, this is not a programmatic approach.  If you want to configure something different, you add data to the Source of Truth as opposed to writing another Ansible playbook or Python script.  We firmly believe that most network operators should not need to become programmers; however, they will have to learn a new skillset including APIs, data models, and data manipulation.

When fully implemented, MDD requires a similar skillset to cloud operations.  That is, when a network operator wants to configure, validate, or test something new, they just need to know how to add data to the Source of Truth and manipulate schemas.  Furthermore, MDD can fit into existing CI/CD pipelines as opposed to needing to operate the network infrastucture differently.  This allows for a de-siloization of IT making it possible to leverage developers and DevOps Engineers across application development, cloud operations, and network operations.  This is because the MDD pipeline looks the same as any other code (or IaC) pipeline:

![MDD Branch Flow](exercises/mdd_branching.png?raw=true "MDD Branch Flow")

This workflow allows for a group of network engineers and network operators to collaborate on a change, test that change, get approvals, then push that change into the production network.  MDD's testing methodologies include linting the configuration data for typos, validating the configuration data for anything that would violate organization norms or create vulnerabilities, and then testing the result of that change in a network before deployment:

![MDD CI Flow](exercises/mdd_ci_flow.png?raw=true "MDD CI Flow")

The goal is to find a bad configuration before it is pushed into the network.

## MDD Reference implementation

This is the reference implementation for Model-Driven Devops as outlined in the book.  While the book captures the reference implementation at a moment in time, te code in this repo will evolve while holding true to the core concepts presented in the book.

### Topology

![MDD Reference Topology](exercises/mdd_topo.png?raw=true "MDD Reference Topology")

### Exercises

These exercises are provided to help get hands-on experience with the reference implemntation.  The book into depth on the individual steps as well as the core concepts behind them.

* [Initial Setup](exercises/initial-setup.md)
* [Deploying the Topology](exercises/deploy-topology.md)
* [Exploring the Inventory](exercises/explore-inventory.md)
* [Exploring the Data](exercises/explore-data.md)
* [Exercising the Runner](exercises/explore-runner.md)
* [Data Validation](exercises/data-validation.md)
* [Pushing the Data](exercises/push-data.md)
* [State Checking](exercises/check-state.md)
