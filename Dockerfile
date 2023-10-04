FROM --platform=linux/amd64 ubuntu:22.04

ARG build_date=unspecified

# workspace location
ARG WORKSPACE
ENV WORKSPACE ${WORKSPACE:-/ansible}
ENV ANSIBLE_COLLECTIONS_PATH /


# LABEL org.opencontainers.image.title="MDD" \
#       org.opencontainers.image.description="Model-Driven DevOps" \
#       org.opencontainers.image.vendor="MDD" \
#       org.opencontainers.image.created="${build_date}" \
#       org.opencontainers.image.url="https://github.com/model-driven-devops/mdd"

COPY requirements.txt /tmp/requirements.txt
COPY requirements.yml /tmp/requirements.yml
USER root
RUN mkdir /root/.ssh && bash -c 'echo -e "Host *\n  KexAlgorithms +diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1" > /root/.ssh/config'
RUN mkdir /ansible_collections && chmod 777 /ansible_collections
RUN apt-get update && \
    apt-get install -y python3.10 python3-pip sshpass git && \
    pip3 install --upgrade --no-cache-dir setuptools pip && \
    echo "===> Installing PIP Requirements <==="  && \
    pip3 install --no-cache -r /tmp/requirements.txt && \
    echo "===> Installing Ansible Collections <===" && \
    rm -rf /var/lib/apt/lists/* && \
    ansible-galaxy collection install -r /tmp/requirements.yml

ENV ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_SSH_PIPELINING=true

WORKDIR ${WORKSPACE} 