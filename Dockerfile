FROM registry1.dso.mil/ironbank/opensource/python/python38

ARG build_date=unspecified

# workspace location
ARG WORKSPACE
ENV WORKSPACE ${WORKSPACE:-/ansible}
ENV ANSIBLE_COLLECTIONS_PATH /


# LABEL org.opencontainers.image.title="Cisco-SDWAN" \
#       org.opencontainers.image.description="Cisco SDWAN DevOps" \
#       org.opencontainers.image.vendor="Cisco Systems" \
#       org.opencontainers.image.created="${build_date}" \
#       org.opencontainers.image.url="https://github.com/CiscoDevNet/sdwan-devops"

COPY requirements.txt /tmp/requirements.txt
COPY requirements.yml /tmp/requirements.yml
USER root
RUN mkdir /ansible_collections && chmod 777 /ansible_collections
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum -y install git sshpass && \
    pip3 install --upgrade --no-cache-dir setuptools pip && \
    echo "===> Installing PIP Requirements <==="  && \
    pip3 install --no-cache -r /tmp/requirements.txt && \
    echo "===> Installing Ansible Collections <===" && \
    ansible-galaxy collection install -r /tmp/requirements.yml

ENV ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_SSH_PIPELINING=true

WORKDIR ${WORKSPACE}
