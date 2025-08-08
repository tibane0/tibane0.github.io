---
layout: post
title: Binary Exploitation Docker Environment
date: 2025-07-23
categories:
  - pwn
  - offsec-lab
  - rev
---
# Setting Up  Pwn Environment Lab with Docker

Reverse Engineering and binary exploitation require a well-configured environment with the right tools. Learning binary exploitation requires to learn on older environment which can be tedious to setup due to dependency conflicts, outdated packages, and compatibility issues.

In this blog we'll walk through building a docker-based pwn environment that includes:
- **Ubuntu 16.04** 
- **GDB + GEF** (debugging)
- **Pwntools** (exploit development)
- Radare2 (reverse engineering)

This setup ensures reproducibiility and isolation, making it great for CTFS, and exploit development.

## Why Docker for the environment
- Consistency - 
- Isolation
- Reproduciblity
- Legacy Support

## Setup
### 1. Copy the dockerfile contents.

```dockerfile
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \ 
    crash volatility \
    wget curl file\
    git vim nano sudo \
    p7zip-full netcat-traditional \
    nasm binutils \
    gcc gcc-multilib g++ g++-multilib \
    make socat \
    texinfo \
    binwalk \
    libgmp-dev libmpfr-dev libmpc-dev \
    strace ltrace patchelf unzip \
    libbz2-dev libreadline-dev libsqlite3-dev \
    libffi-dev libncurses5-dev libgdbm-dev liblzma-dev \
    zlib1g-dev ca-certificates software-properties-common \
    libnss3-dev libncurses-dev\
    && rm -rf /var/lib/apt/lists/*



RUN apt-get update && apt-get install -y \
    software-properties-common  android-tools-adb \
    android-tools-fastboot


# Install Java 11 (via PPA)
RUN add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get install -y openjdk-11-jdk

    # Install Android SDK (manually)
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O /tmp/android-sdk.zip && \
unzip /tmp/android-sdk.zip -d /opt/android-sdk && \
rm /tmp/android-sdk.zip
ENV ANDROID_HOME=/opt/android-sdk

# Install Apktool (manually)
RUN wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -O /usr/local/bin/apktool && \
    wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.8.1.jar -O /usr/local/bin/apktool.jar && \
    chmod +x /usr/local/bin/apktool


    # Install Jadx (manually)
RUN wget https://github.com/skylot/jadx/releases/download/v1.4.7/jadx-1.4.7.zip -O /tmp/jadx.zip && \
unzip /tmp/jadx.zip -d /opt/jadx && \
rm /tmp/jadx.zip && \
ln -s /opt/jadx/bin/jadx /usr/local/bin/jadx && \
ln -s /opt/jadx/bin/jadx-gui /usr/local/bin/jadx-gui


# EMBEDDED/IOT Exploiattion
RUN apt-get update && apt-get install -y \
    binwalk \
    qemu \
    qemu-user \
    qemu-system \
    qemu-user-static \
    qemu-system-arm \
    qemu-system-mips \
    squashfs-tools

# Build OpenSSL 1.1.1 (required for Python 3.10+ SSL support)
WORKDIR /usr/src
RUN wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz && \
    tar xzf openssl-1.1.1w.tar.gz && \
    cd openssl-1.1.1w && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib && \
    make -j$(nproc) && make install && \
    echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf && ldconfig

# Build Python 3.10 with OpenSSL support
RUN wget https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz && \
    tar xzf Python-3.10.13.tgz && \ 
    cd Python-3.10.13 && \
    LDFLAGS="-L/usr/local/openssl/lib -Wl,-rpath=/usr/local/openssl/lib" \
    CPPFLAGS="-I/usr/local/openssl/include" \
    ./configure --enable-optimizations --with-openssl=/usr/local/openssl && \
    make -j$(nproc) && \
    make altinstall

# Setup pip and symlinks
RUN ln -sf /usr/local/bin/python3.10 /usr/bin/python3 && \
    ln -sf /usr/local/bin/python3.10 /usr/bin/python && \
    python3.10 -m ensurepip && \
    python3.10 -m pip install --upgrade pip && \
    ln -sf /usr/local/bin/pip3.10 /usr/bin/pip3 && \
    ln -sf /usr/local/bin/pip3.10 /usr/bin/pip


# Install GDB 14 from source
# Download and build GDB 14.2
RUN cd /tmp && \
    wget https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.gz && \
    tar -xzf gdb-14.2.tar.gz && \
    cd gdb-14.2 && \
    ./configure --prefix=/opt/gdb-14 --with-python=python3 && \
    make -j$(nproc) && \
    make install && \
    # Link GDB to system path
    ln -sf /opt/gdb-14/bin/gdb /usr/local/bin/gdb && \
    ln -sf /opt/gdb-14/bin/gdb /usr/bin/gdb 



# Install Radare2
RUN git clone https://github.com/radareorg/radare2.git /opt/radare2 && \
    cd /opt/radare2 && ./sys/install.sh && cd -

RUN curl -s -o checksec https://raw.githubusercontent.com/slimm609/checksec.sh/${CHECKSEC_STABLE}/checksec \
        && chmod +x checksec && \
        mv checksec /usr/local/bin/ 

# Create user
RUN useradd -m hacker && \
    echo "hacker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/hacker/workspace && \
    chown -R hacker:hacker /home/hacker && \
    chmod -R 755 /home/hacker

USER hacker

WORKDIR /home/hacker/workspace

# Install GEF
RUN wget -q -O ~/.gdbinit-gef.py https://gef.blah.cat/py && \
    echo "source ~/.gdbinit-gef.py" >> ~/.gdbinit

# Install Python tools
RUN pip3 install --user --no-cache-dir pwntools ROPgadget one_gadget unicorn keystone-engine qiling frida frida-tools objection

# Download exploit template with multiple fallbacks
# Inside your Dockerfile
USER root

RUN wget -O /usr/local/bin/exploit_template.py "https://raw.githubusercontent.com/tibane0/ctf-pwn/main/exploit_template.py" || \
    curl -sSLo /usr/local/bin/exploit_template.py "https://raw.githubusercontent.com/tibane0/ctf-pwn/main/exploit_template.py" && \
    chmod +x /usr/local/bin/exploit_template.py

USER hacker 

CMD ["/bin/bash"]
```

### 2. Build the image
```sh
docker build -t pwn-env:latest .
```


### 3. Running the container

```sh
docker run -it --rm --privileged --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  -v "$(pwd)":/home/hacker/workspace \
  pwn-env bash -c 'cp /usr/local/bin/exploit_template.py /home/hacker/workspace/ && exec bash'

```

## Conclusion
This Docker-based pwn environment provides a **clean, reproducible setup** for binary exploitation and reverse engineering. By using **Ubuntu 16.04 + Python 3.9**, we maintain compatibility with older challenges while leveraging modern tools like GEF and pwntools.

Docker eliminates setup headaches, letting you focus on exploitation. Try this and let me know how it can be improved. 

Happy hacking!