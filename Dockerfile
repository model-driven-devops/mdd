FROM alpine:3.11

ARG build_date=unspecified

# LABEL org.opencontainers.image.title="Cisco-SDWAN" \
#       org.opencontainers.image.description="Cisco SDWAN DevOps" \
#       org.opencontainers.image.vendor="Cisco Systems" \
#       org.opencontainers.image.created="${build_date}" \
#       org.opencontainers.image.url="https://github.com/CiscoDevNet/sdwan-devops"

COPY requirements.txt /tmp/requirements.txt

RUN echo "===> Installing GCC <===" && \
    apk add --no-cache gcc musl-dev make

RUN echo "===> Installing Python <===" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi

RUN echo "===> Installing pip <===" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN echo "===> Installing dependancies <==="  && \
    apk --update add sshpass libxml2-dev libxslt-dev libffi-dev python3-dev openssl-dev openssh-keygen

RUN echo "===> Installing PIP Requirements <==="  && \
    pip install -r /tmp/requirements.txt

ENV ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_SSH_PIPELINING=true

WORKDIR /ansible
