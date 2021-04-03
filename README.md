# model-driven-devops
This repo contains a set of tools to automate workflows and build CI/CD pipelines for Cisco networks.

> Note: The tools in this repo only work from a Unix environment with Docker (e.g. Linux, MacOS, etc.) due to issues with Ansible and file permissions mapping between Windows and the Linux container used in `play.sh`.  WSL2 may fix this issue and we will revisit when WSL2 is released.

## Requirements
- [Docker](https://www.docker.com) - required to run playbooks using the `play.sh` wrapper
- [Cisco Modeling Labs](https://www.cisco.com/c/en/us/products/cloud-systems-management/modeling-labs/index.html) - required to simulate the topology
- [GitLab](https://about.gitlab.com) - required for version control and CI

## Setup

1. Clone the repo.
    ```
    git clone https://github.com/ciscops/model-driven-devops.git
    ```

1. This repo deploys using a Network Services Orchestrator image created from https://github.com/ciscops/cml-custom-images.
   Edit './inventory/arch2/nso.yml' with the appropriate NSO variables. For example
   ```   
   admin_user: ubuntu
   admin_password: admin
   nso_install_dir: /pkgs/nso-install
   nso_run_dir: /home/ubuntu/ncs-run
   nso_ned_id: cisco-ios-cli-6.69
   ```
1. You may need to verify/edit node_definition and image_definition names for your CML deployment in './files/arch2.yaml'.

1. Change to the model-driven-devops directory.
    ```
    cd model-driven-devops
    ```
    >Note: all future commands should be executed from this directory.

1. If using CoLaboratory, build gitlab deployment. 
    ```   
    In WebEx, send COLABOT "gitlab build" command
    ```
   >Note: This will take approximately 10 minutes.

1. If using CoLaboratory, log into GitLab and create GITLAB_API_TOKEN
   - Use your personal GitLab deployment URL, username, and password messaged to you by COLABOT
   - In the upper left of console, click on the symbol for your account and then Settings
   - In the left menu, click on "Access Tokens"
   - Provide a token name, expiration, the api scope, click "Create personal access token", and save the generated TOKEN for the next step

1.  Export the following variables to match your environment.
    ```
    export VIRL_HOST=cml.example.com
    export VIRL_USERNAME=
    export VIRL_PASSWORD=
    export VIRL_LAB=my_lab
    export CML_VERIFY_CERT=false
    export GITLAB_HOST=https://gitlab.example.com
    export GITLAB_USER=
    export GITLAB_API_TOKEN=
    export GITLAB_PROJECT=model-driven-devops
    ```

## Create a CI pipeline in GitLab

1. Create the GitLab project and CI/CD variables.
    ```
    extras/create-gitlab-project.sh
    ```

1. Remove the old origin, add new origin and push to GitLab.
    ```
    git remote remove origin
    git remote add origin $GITLAB_HOST/$GITLAB_USER/$GITLAB_PROJECT.git
    git config http.version HTTP/1.1
    git push --set-upstream origin master
    ```

    >Note: enter your GitLab credentials if asked

1. From the GitLab web UI, navigate to the CI/CD -> Pipelines page for the project. You should see a pipeline currently active since we committed the model-driven-devops code and we had a `.gitlab-ci.yml` file present. If that file is present, GitLab will automatically try to execute the CI pipeline defined inside.

1. Use the graphical representation of the pipeline to click through the console output of the various stages. The entire pipeline will take approximately ~8 minutes to complete. Wait until it completes to go onto the next step.

## Cleanup
1. Remove project from GitLab.
    ```
    extras/delete-gitlab-project.sh
    ```

1. Delete lab from CML.
    ```
    ./play.sh clean-cml.yml
    ```
