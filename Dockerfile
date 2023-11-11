ARG BASE=ubuntu:jammy
FROM ${BASE}

ARG DEBIAN_FRONTEND=noninteractive

# package list specified here:
# https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html
# Plus ca-certificates because of a let's encrypt issue with ubuntu:jammy
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      gawk \
      wget \
      git \
      diffstat \
      unzip \
      texinfo \
      gcc \
      build-essential \
      chrpath \
      socat \
      cpio \
      python3 \
      python3-pip \
      python3-pexpect \
      xz-utils \
      debianutils \
      iputils-ping \
      python3-git \
      python3-jinja2 \
      libegl1-mesa \
      libsdl1.2-dev \
      python3-subunit \
      mesa-common-dev \
      zstd \
      liblz4-tool \
      file \
      locales \
      ca-certificates\
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

ENV NICE=19
ENV BBARGS=
ENV BBRECIPE=picard-carbleurator
CMD bash -c 'source source/openembedded-core/oe-init-build-env && nice -n ${NICE} bitbake ${BBARGS} ${BBRECIPE}'
