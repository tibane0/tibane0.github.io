
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
# Use Ubuntu 16.04 base
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget file \
    curl \
    git \
    vim \
    p7zip-full tar netcat-traditional \
    nasm binutils \
    nano \
    make \
    gcc gcc-multilib \
    g++ g++-multilib \
    gdb \
    netcat \
    socat \
    strace \
    ltrace \
    patchelf \
    unzip \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    libncurses5-dev \
    libgdbm-dev \
    liblzma-dev \
    zlib1g-dev \
    ca-certificates \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Build and install Python 3.9.18 from source
WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tgz && \
    tar xzf Python-3.9.18.tgz && \
    cd Python-3.9.18 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd .. && rm -rf Python-3.9.18*

# Set Python 3.9 as default and install pip
RUN ln -sf /usr/local/bin/python3.9 /usr/bin/python3 && \
    ln -sf /usr/local/bin/python3.9 /usr/bin/python && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9 && \
    ln -sf /usr/local/bin/pip3.9 /usr/bin/pip3 && \
    ln -sf /usr/local/bin/pip3.9 /usr/bin/pip && \
    pip3 install --upgrade pip

# Install pwntools and ROPgadget
RUN pip3 install --no-cache-dir pwntools ROPgadget

# Install GEF for GDB (latest version)
RUN wget -q -O /root/.gdbinit-gef.py https://gef.blah.cat/py && \
    echo "source /root/.gdbinit-gef.py" >> /root/.gdbinit

# Install Radare2 from source (latest stable)
RUN git clone --depth 1 https://github.com/radareorg/radare2.git /opt/radare2 && \
    cd /opt/radare2 && ./sys/install.sh && cd - 


# Create non-root user
RUN useradd -m -s /bin/bash hacker && \
    mkdir -p /home/hacker/workspace && \
    chown -R hacker:hacker /home/hacker

WORKDIR /home/hacker/workspace
USER hacker


# Install GEF for GDB (latest version)
RUN wget -q -O /home/hacker/.gdbinit-gef.py https://gef.blah.cat/py && \
    echo "source /home/hacker/.gdbinit-gef.py" >> /home/hacker/.gdbinit

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
  -v $(pwd):/home/hacker/workspace pwn-env-latest

```

## Conclusion
This Docker-based pwn environment provides a **clean, reproducible setup** for binary exploitation and reverse engineering. By using **Ubuntu 16.04 + Python 3.9**, we maintain compatibility with older challenges while leveraging modern tools like GEF and pwntools.

Docker eliminates setup headaches, letting you focus on exploitation. Try this and let me know how it can be improved. 

Happy hacking!