FROM rust:1.67.1 AS build
ENV RUSTFLAGS='-C target-feature=+crt-static'
RUN cargo new /app
WORKDIR /app
RUN cargo update
COPY Cargo.toml /app/
RUN cargo fetch
RUN cargo build --release --target x86_64-unknown-linux-gnu
COPY src/main.rs /app/src/main.rs
RUN cargo build --release --target x86_64-unknown-linux-gnu

FROM scratch
WORKDIR /
ENV ROCKET_CONFIG=/app/Rocket.toml
COPY Rocket.toml /app/
COPY --from=build /app/target/x86_64-unknown-linux-gnu/release/hello-rocket /server
ENTRYPOINT ["/server"]
