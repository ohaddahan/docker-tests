FROM --platform=$BUILDPLATFORM alpine AS build
ARG DEBIAN_FRONTEND=noninteractive
ARG SQLX_VERSION=0.7.3
ARG LEPTOS_VERSION=0.2.20
ARG RUSTC_VERSION=1.77.0
ARG WASM_PACK=0.12.1
ARG TARGETPLATFORM
ARG DEBIAN_FRONTEND=noninteractive
ARG SQLX_VERSION=0.7.3
ARG LEPTOS_VERSION=0.2.20
ARG RUSTC_VERSION=1.77.0
ARG WASM_PACK=0.12.1
ARG COMMAND
RUN apk update
RUN apk add zig
RUN apk add curl gzip git
RUN apk add g++ make gcc build-base
RUN apk add pkgconfig openssl libressl-dev musl-dev python3-dev libffi-dev
RUN apk add bash
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install $RUSTC_VERSION
RUN rustup default $RUSTC_VERSION
RUN rustup component add rustfmt
RUN rustup component add rustc
RUN rustup component add cargo
RUN rustup component add rust-std
RUN rustup component add rust-docs
RUN rustup component add rust-analyzer
RUN rustup component add clippy
RUN rustup component add rust-src
RUN rustup target add wasm32-unknown-unknown
RUN apk add openssl ca-certificates
RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add aarch64-unknown-linux-gnu
RUN cargo install cargo-leptos --features no_downloads --version=$LEPTOS_VERSION
RUN cargo install sqlx-cli --version=$SQLX_VERSION --no-default-features --features postgres,rustls
#RUN cargo install wasm-pack --version=$WASM_PACK
RUN cargo install bunyan
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
RUN cargo install --locked cargo-zigbuild
RUN apk add nodejs npm
RUN npm install -g sass
RUN cargo install cross
RUN apk add --update docker openrc
RUN rustup target add aarch64-unknown-linux-musl
RUN rustup component add rust-std --target x86_64-unknown-linux-gnu
RUN rustup component add rust-src --target x86_64-unknown-linux-gnu
RUN rustup component add rust-std --target aarch64-unknown-linux-gnu
RUN rustup component add rust-src --target aarch64-unknown-linux-gnu
RUN rustup component add rust-std --target aarch64-unknown-linux-musl
RUN rustup component add rust-src --target aarch64-unknown-linux-musl

FROM build AS run
WORKDIR /code
EXPOSE 8000
#COPY ./file.sh /
#RUN chmod 755 /file.sh
#CMD ["/bin/bash", "-c", "$COMMAND"]
ENTRYPOINT [ "/code/file.sh" ]


