FROM jenkins/inbound-agent:latest

ARG ansible_repository="https://github.com/ansible/ansible.git"
ARG ansible_version="2.12.10"
ARG kubectl_version="1.25.4"
ARG terraform_version="1.3.5"

ENV ANSIBLE_HOME="/opt/ansible"
ENV PATH="${ANSIBLE_HOME}/bin:${PATH}"
ENV PYTHONPATH="${ANSIBLE_HOME}/lib:${PYTHONPATH}"

USER root

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends \
      git-crypt \
      python-is-python3 \
      python3 \
      python3-cryptography \
      python3-jinja2 \
      python3-packaging \
      python3-resolvelib \
      python3-yaml \
 && rm -rf /var/lib/apt/lists/* \
 && git -C /opt clone --branch "v${ansible_version}" --depth 1 "${ansible_repository}" \
 && curl -sSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/v${kubectl_version}/bin/linux/amd64/kubectl" \
 && chmod 0755 /usr/local/bin/kubectl \
 && curl -sSL -o terraform.zip "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" \
 && unzip terraform.zip -d /usr/local/bin \
 && chmod 0755 /usr/local/bin/terraform

USER jenkins
