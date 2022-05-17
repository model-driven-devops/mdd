# Model-Driven DevOps
This is a reference implementation for Model-Driven Devops as outlined in the book ["Model-Driven DevOps: Increasing agility and security in your physical network through DevOps"](https://www.informit.com/store/model-driven-devops-increasing-agility-and-security-9780137644674) ([Amazon](https://www.amazon.com/Model-driven-Devops-Increasing-Security-Physical/dp/0137644671/ref=sr_1_1?crid=1X8MTIAXRKLMI&keywords=model-driven+devops&qid=1650992113&sprefix=model-driven+devop%2Caps%2C202&sr=8-1)).  While the book captures the reference implementation at a moment in time, this reference implementation will evolve while holding true to the core concepts presented in the book.

## What is Model-Driven DevOps?
Model-Driven Devops (MDD) is an Infrastructure as Code (IaC) approach to automating physical infrastrcuture that focuses on data organization and movement into the network in a way that seeks to treat the network the same as other parts of the infrastructure.  MDD focuses on using industry standard tools and best practices while leveraging DevOps methodologies implemented as a Continuous Integration / Continuous Delivery (CI/CD) pipeline to break down silos that typically exist between network operations and the rest of the infrastructure operations.  For example, this is a common flow in Cloud Operations:

![Cloud Ops Flow](exercises/cloud_ops_flow.png?raw=true "Cloud Ops Flow")

The key to this flow is that all of the data (Source of Truth) needed to configure the infrastructure is in the data file Cloud Formation Template (CFT Template).  Also, this is not a programatic approach.  If an operator requires a configuration change or modification, the data changes are added to the Source of Truth (CFT Template) as opposed to writing another Ansible playbook or python script.  While we firmily believe that most network operators should not need to become programmers, they will have to learn a new skillset that includes knowledge of APIs, data models, and data manipulation.

When fully implemented, MDD requires a similar skillset to cloud operations.  That is, when a network operator wants to configure, validate, or test something new, they only need to know how to add/modify the data to the Source of Truth and manipulate the schemas.  Furthermore, MDD can fit into any exsiting CI/CD pipeline as opposed to operating the network infrastucture differently.  This allows for a de-siloization of IT making it possible to leverage both developers and DevOps Engineers across application development, cloud operations, and network operations.  This is because the MDD pipeline (shown below) looks the same as any other code (or IaC) pipeline:

![MDD Branch Flow](exercises/mdd_branching.png?raw=true "MDD Branch Flow")

This workflow allows for a group of network engineers and network operators to collaborate on a change, test that change, get approvals, then push that change into the production network.  MDD's testing metholdolgies include linting the configuration data for typos, validating the configuration data for anything that would violate organization norms or create vulnerabilities, and then testing the result of those changes in a "test network" prior to deployment:

![MDD CI Flow](exercises/mdd_ci_flow.png?raw=true "MDD CI Flow")

The goal is to find a bad configuration before it is pushed into the production network.

## MDD Reference implementation

![MDD Reference Topology](exercises/mdd_topo.png?raw=true "MDD Reference Topology")

## Exercises
* [Initial Setup](exercises/initial-setup.md)
* [Deploying the Topology](exercises/deploy-topology.md)
* [Exploring the Inventory](exercises/explore-inventory.md)
* [Exploring the Data](exercises/explore-data.md)
* [Exercising the Runner](exercises/explore-runner.md)
* Data Validation
* Pushing the Data
* State Checking
