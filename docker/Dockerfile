FROM --platform=$BUILDPLATFORM nvidia/cuda:12.4.1-devel-ubuntu22.04

# ULTRATHINK ε₀ FRACTAL WEIGHT ENGINE
# Production GPU image

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    libclang-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /usr/src/ultrathink-engine

# Cache cargo deps
COPY Cargo.toml Cargo.lock* ./
RUN mkdir src && echo 'fn main() {}' > src/lib.rs && \
    cargo build --release && rm -rf src

# Source
COPY . .

# Production build
RUN cargo build --release

# Chaos testing
RUN cargo install cargo-chaos

EXPOSE 8080

CMD ["./target/release/ultrathink-engine", "--chaos", "--production"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1