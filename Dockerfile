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
    ninja \
    radare2 \
    radare2-dev

WORKDIR /build

RUN r2pm -Uci r2mcp

# Create /data volume for binary analysis
WORKDIR /data
VOLUME ["/data"]

# Environment setup for r2mcp
ENV R2MCP_DEBUG=0

# Simply set the entrypoint
ENTRYPOINT ["r2pm", "-r", "mcp"]

# Instructions for users:
# IMPORTANT: Always run with `-i` flag to keep stdin open:
#   docker run -i --rm r2mcp
