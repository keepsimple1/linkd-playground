set -euo pipefail
export $(cat env)

#RUSTFLAGS="--cfg tokio_unstable" cargo build \
cargo build \
    --target-dir ./target \
    --manifest-path $LINK_CHECKOUT/bins/Cargo.toml \
    -p lnk-gitd;
peer_id=$(LNK_HOME=/tmp/link-local-1 \
    cargo run \
        --target-dir ./target \
        --manifest-path $LINK_CHECKOUT/bins/Cargo.toml \
        -p lnk -- profile peer);

systemd-socket-activate \
    -l 9987 \
    --fdname=ssh \
    -E SSH_AUTH_SOCK \
    -E RUST_BACKTRACE=1 \
    -E RUST_LOG=librad=trace,link_crypto=info,gitd_lib=trace,rustls=info,futures_lite=info \
    ./target/debug/lnk-gitd \
    /tmp/link-local-1 \
    --linkd-rpc-socket $XDG_RUNTIME_DIR/link-peer-$peer_id-rpc.socket \
    --push-seeds \
    --fetch-seeds \
    --linger-timeout 10000
