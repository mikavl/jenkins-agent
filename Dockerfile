FROM jenkins/inbound-agent:latest

ARG TARGETARCH

ARG ansible_repository="https://github.com/ansible/ansible.git"
ARG ansible_version="2.12.10"
ARG helm_version="3.10.2"
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
      unzip \
 && rm -rf /var/lib/apt/lists/* \
 && git -C /opt clone --branch "v${ansible_version}" --depth 1 "${ansible_repository}" \
 && curl -sSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/v${kubectl_version}/bin/linux/${TARGETARCH}/kubectl" \
 && chmod 0755 /usr/local/bin/kubectl \
 && curl -sSL -o terraform.zip "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_${TARGETARCH}.zip" \
 && unzip terraform.zip -d /usr/local/bin \
 && rm -f terraform.zip \
 && chmod 0755 /usr/local/bin/terraform \
 && install -d -m 0700 -o jenkins -g jenkins /home/jenkins/.terraform.d /home/jenkins/.terraform.d/plugin-cache \
 && curl -sSL -o helm.tar.gz "https://get.helm.sh/helm-v${helm_version}-linux-${TARGETARCH}.tar.gz" \
 && tar -xvf helm.tar.gz \
 && rm -f helm.tar.gz \
 && install -m 0755 -o root -g root "linux-${TARGETARCH}/helm" /usr/local/bin \
 && rm -rf "linux-${TARGETARCH}"

COPY --chown=jenkins:jenkins .terraformrc /home/jenkins

USER jenkins
