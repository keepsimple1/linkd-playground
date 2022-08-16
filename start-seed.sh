set -euo pipefail
export $(cat env)

#RUSTFLAGS="--cfg tokio_unstable" cargo build \
cargo build \
    --target-dir ./target \
    --manifest-path $LINK_CHECKOUT/bins/Cargo.toml \
    -p linkd;
RUST_LOG=librad=info,linkd_lib=info,lnk_clib=info \
    ./target/debug/linkd \
    --lnk-home /tmp/seed-home \
    --track everything \
    --protocol-listen 127.0.0.1:8799

