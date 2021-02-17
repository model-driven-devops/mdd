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
    git clone -b cidr-919 https://github.com/ciscops/model-driven-devops.git
    ```

1. Change to the model-driven-devops directory.
    ```
    cd model-driven-devops
    ```
    >Note: all future commands should be executed from this directory.

1.  Export the following variables to match your environment.
    ```
    export VIRL_HOST=cml.example.com
    export VIRL_USERNAME=
    export VIRL_PASSWORD=
    export VIRL_LAB=my_lab
    export GITLAB_HOST=https://gitlab.example.com
    export GITLAB_USER=
    export GITLAB_API_TOKEN=
    export GITLAB_PROJECT=model-driven-devops
    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=
    export AWS_REGION=
    export AWS_BUCKET=
    ```

    > Note: AWS S3 bucket used for NSO packages

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
    git push --set-upstream origin cidr-919
    ```

    >Note: enter your GitLab credentials if asked

1. From the GitLab web UI, navigate to the CI/CD -> Pipelines page for the project. You should see a pipeline currently active since we commited the model-driven-devops code and we had a `.gitlab-ci.yml` file present. If that file is present, GitLab will automatically try to execute the CI pipeline defined inside.

1. Use the graphical representation of the pipeline to click through the console output of the various stages. The entire pipeline will take approximately ~8 minutes to complete. Wait until it completes to go onto the next step.

## Modify infrastructure-as-code to exercise the CI pipeline
1. From the shell, run the `cml-inventory.yml` playbook to find your **site1-rtr1** IP-address.
    ```
    ./play.sh --limit "site1-rtr1" cml-inventory.yml
    ```

1. SSH to the site1-rtr1 IP-address, using credentials admin/admin.
    ```
    ssh admin@<your site1-rtr1 IP-address>
    ```

1. Verify the banner when you login. It should look something like:
    ```
    % ssh admin@192.133.186.206
    Password: 
    Welcome to site1-rtr1!
    ```
1. Exit out of the ssh session.

1. Edit the `inventory/arch1/group_vars/all/system.yml` file and replace the line containing `banner_motd`.
    Replace:
    ```
    'banner_motd': "Welcome to {{ inventory_hostname }}!"
    ```
    with:
    ```
    'banner_motd': "Cisco DevNet is awesome!"
    ```

1. Save the file.

1. Add the file for commit and commit the file.
    ```
    git add inventory/arch1/group_vars/all/system.yml
    git commit -m "Updated MOTD banner"
    ```

1. Push the commit to GitLab.
    ```
    git push
    ```

1. From the GitLab web UI, navigate to the CI/CD -> Pipelines page. You should have a new pipeline being run based off the change you pushed to GitLab. Wait for the pipeline to complete.

1. From the shell, SSH to site1-rtr1 and verify the new banner.

## View the change control information in GitLab
1. From the GitLab UI, select Repository -> Commits.

1. Click on the latest commit and view the diff of the change, who made the change, when it was made and whether it passed the CI pipeline.

1. Congratulations! You created a fully functioning CI pipeline for a model-driven network.

## Making a change that fails validation
1. From the shell, edit the `inventory/arch1/host_vars/site1-rtr1/network.yml` file and change the `primary` IP address for GigabitEthernet2.  Replace:
    ```
    primary: 192.168.1.1/24
    ```
    with:
    ```
    primary: 192.168.254.1/24
    ```

1. Save the file.

1. Add the file for commit and commit the file.
    ```
    git add inventory/arch1/host_vars/site1-rtr1/network.yml
    git commit -m "Updated site1-rtr1 LAN interface"
    ```

1. Push the commit to GitLab.
    ```
    git push
    ```

1. From the GitLab web UI, navigate to the Repository -> Commits page. You should have a new commit titled "Updated site1-rtr1 LAN interface".

1. Click on the commit to see the details.  Note who made the change, what changed and the pipeline status.

1. Because we changed the address of the site1-rtr1 LAN interface, we should have effectively broken the validation tests for site1 because end hosts on the LAN will not be able to access their default gateway anymore.

1. Verify that the pipeline failed.

## Revert a change that fails validation
1. Now let's roll back that change since it failed validation.  Select Options -> Revert from the menu in the upper right corner.

1. Uncheck "Start a new merge request with these changes" and then click "Revert".

1. This will generate a new commit for the revert operation that will back out the change to the **site1-rtr1** LAN interface.

1. Follow this commit until the pipeline completes successfully.

1. To assure the central repo in GitLab is in-sync with the local repo, go back to the shell and execute the following command:
    ```
    git pull
    ```
1. Verify in the `inventory/arch1/host_vars/site1-rtr1/network.yml` file that the `GigabitEthernet2` address reverted back to 192.168.1.1/24:

    ```
    primary: 192.168.1.1/24
    ```

1. Congratulations! You have built and used a CI pipeline to validate and operate a Cisco model-driven network.

## Cleanup
1. Remove project from GitLab.
    ```
    extras/delete-gitlab-project.sh
    ```

1. Delete lab from CML.
    ```
    ./play.sh clean-cml.yml
    ```
