#!/bin/bash
docker pull ghcr.io/cross-rs/aarch64-unknown-linux-gnu:0.2.5 --platform linux/x86_64
docker build --platform linux/arm64 -t docker-tests -f ubuntu.Dockerfile --load .

docker --platform linux/arm64 run -v ./:/code -v ./target-docker:/code/target -t docker-tests -e COMMAND="LEPTOS_BIN_TARGET_TRIPLE=x86_64-unknown-linux-gnu cargo leptos build"


docker run --platform linux/arm64 -it -v ./:/code -v /var/run/docker.sock:/var/run/docker.sock -v ./target-docker:/code/target --entrypoint /bin/bash -t docker-tests
