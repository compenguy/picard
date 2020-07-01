ARG BASE=ubuntu:bionic
FROM ${BASE}

ARG DEBIAN_FRONTEND=noninteractive

# package list specified here:
# https://www.yoctoproject.org/docs/2.0/yocto-project-qs/yocto-project-qs.html
RUN apt-get update \
    && apt-get install -y \
      python3 \
      python3-distutils \
      gawk \
      wget \
      git-core \
      diffstat \
      unzip \
      texinfo \
      gcc-multilib \
      build-essential \
      chrpath \
      socat \
      cpio \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
      locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

VOLUME /home/yocto
RUN useradd -s /bin/bash -d /home/yocto -gusers -Gstaff,sudo yocto \
    && chown 1000:100 /home/yocto \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER yocto
WORKDIR /home/yocto

ENV IMAGE=picard-minimal
CMD bash -c 'source source/openembedded-core/oe-init-build-env && bitbake ${IMAGE}'
