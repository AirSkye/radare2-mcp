FROM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    pkgconfig \
    python3 \
    libc-dev \
    file-dev \
    libzip-dev \
    openssl-dev \
    linux-headers \
    meson \
    ninja

WORKDIR /build
# Install radare2 (for build only)
RUN git clone --depth 1 https://github.com/radareorg/radare2.git && \
    sed -i '/static ssize_t process_vm_readv/d; /static ssize_t process_vm_writev/d' radare2/libr/io/p/io_pvm.c && \
    ./radare2/sys/install.sh

RUN git clone --depth 1 https://github.com/radareorg/radare2-mcp.git && \
    cd radare2-mcp && \
    make && \
    cp r2mcp /usr/local/bin/

# Create /data volume for binary analysis
WORKDIR /data
VOLUME ["/data"]

# Environment setup for r2mcp
ENV R2MCP_DEBUG=0

# Simply set the entrypoint
ENTRYPOINT ["/usr/local/bin/r2mcp"]

# Instructions for users:
# IMPORTANT: Always run with `-i` flag to keep stdin open:
#   docker run -i --rm r2mcp
