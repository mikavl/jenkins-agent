FROM jenkins/inbound-agent:latest

ARG ansible_repository="https://github.com/ansible/ansible.git"
ARG ansible_version="2.12.10"

ENV ANSIBLE_HOME="/opt/ansible"
ENV PATH="${ANSIBLE_HOME}/bin:${PATH}"
ENV PYTHONPATH="${ANSIBLE_HOME}/lib:${PYTHONPATH}"

USER root

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends \
      python-is-python3 \
      python3 \
      python3-cryptography \
      python3-jinja2 \
      python3-packaging \
      python3-resolvelib \
      python3-yaml \
 && rm -rf /var/lib/apt/lists/* \
 && git -C /opt clone --branch "v${ansible_version}" --depth 1 "${ansible_repository}"

USER jenkins
