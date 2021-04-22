FROM python:3.6-slim

ARG build_date=unspecified

# workspace location
ARG WORKSPACE
ENV WORKSPACE ${WORKSPACE:-/ansible}

# LABEL org.opencontainers.image.title="Cisco-SDWAN" \
#       org.opencontainers.image.description="Cisco SDWAN DevOps" \
#       org.opencontainers.image.vendor="Cisco Systems" \
#       org.opencontainers.image.created="${build_date}" \
#       org.opencontainers.image.url="https://github.com/CiscoDevNet/sdwan-devops"

COPY requirements.txt /tmp/requirements.txt
COPY requirements.yml /tmp/requirements.yml
RUN apt-get update && \
    apt-get install -y --no-install-recommends iputils-ping telnet openssh-client curl build-essential sshpass && \
    pip3 install --upgrade --no-cache-dir setuptools pip && \
    echo "===> Installing PIP Requirements <==="  && \
    pip3 install --no-cache -r /tmp/requirements.txt && \
    echo "===> Installing Ansible Collections <===" && \
    ansible-galaxy collection install -r /tmp/requirements.yml && \
    apt-get remove -y curl build-essential && \
    apt-get autoremove -y && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN echo "===> Installing dependancies <==="  && \
#     apk add --no-cache busybox-extras openssh-client && \  
#     apk add --no-cache --virtual .build-deps  \
# 		bzip2-dev \
# 		coreutils \
# 		dpkg-dev dpkg \
# 		expat-dev \
# 		findutils \
# 		gcc \
# 		gdbm-dev \
# 		libc-dev \
# 		libffi-dev \
# 		libnsl-dev \
# 		libtirpc-dev \
# 		linux-headers \
# 		make \
# 		ncurses-dev \
# 		openssl-dev \
# 		pax-utils \
# 		readline-dev \
# 		sqlite-dev \
# 		tcl-dev \
# 		tk \
# 		tk-dev \
# 		util-linux-dev \
# 		xz-dev \
# 		zlib-dev \
#         sshpass \
#         libxml2-dev \
#         libxslt-dev \
#         libffi-dev \
#         openssl-dev \
#         openssh-keygen
    # echo "===> Installing GCC <===" && \
    # apk add --no-cache gcc musl-dev make && \
    # echo "===> Installing Python <===" && \
    # apk add --no-cache python3 && \
    # if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi


# RUN echo "===> Installing pip <===" && \
#     python3 -m ensurepip && \
#     rm -r /usr/lib/python*/ensurepip && \
#     pip3 install --no-cache --upgrade pip setuptools wheel && \
#     if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \


ENV ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_SSH_PIPELINING=true

WORKDIR ${WORKSPACE}
