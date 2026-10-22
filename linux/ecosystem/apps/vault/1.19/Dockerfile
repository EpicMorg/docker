##################################################################
#        Vault: HashiCorp's release binary (static Go)
##################################################################
# All vault leaves share this file; they differ only in the EMG_VAULT_* block
# (bin/python/vault-versions-sync.py: the CE release of each line, its
# SHA256SUMS checked against HashiCorp's signature, the zip pinned here).
FROM ghcr.io/epicmorg/debian:trixie AS fetch
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_VAULT_VERSION=1.19
ENV EMG_VAULT_FULL_VERSION=1.19.5
ARG EMG_VAULT_SHA256=5192111920b3f745c10f8fea9988c46b91414a69bcf49df1f7c87880d80a3755
ARG EMG_VAULT_URL=https://releases.hashicorp.com/vault/${EMG_VAULT_FULL_VERSION}/vault_${EMG_VAULT_FULL_VERSION}_linux_amd64.zip
ENV EMG_VAULT_DIR=${EMG_LOCAL_BASE_DIR}/vault/${EMG_VAULT_VERSION}

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends unzip; \
    rm -rf /var/lib/apt/lists/*; \
    curl -fsSL -o /tmp/vault.zip "${EMG_VAULT_URL}"; \
    echo "${EMG_VAULT_SHA256}  /tmp/vault.zip" | sha256sum -c -; \
    mkdir -p "/emg-export${EMG_VAULT_DIR}/bin"; \
    unzip -o -q /tmp/vault.zip -d "/emg-export${EMG_VAULT_DIR}/bin"; \
    rm -f /tmp/vault.zip; \
    test -x "/emg-export${EMG_VAULT_DIR}/bin/vault"; \
    find "/emg-export${EMG_VAULT_DIR}/bin" -type f ! -name vault -exec mv {} "/emg-export${EMG_VAULT_DIR}/" \;

##################################################################
##################################################################
#                       Final image
##################################################################
##################################################################
FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

ENV EMG_VAULT_VERSION=1.19
ENV EMG_VAULT_FULL_VERSION=1.19.5
ENV EMG_VAULT_DIR=${EMG_LOCAL_BASE_DIR}/vault/${EMG_VAULT_VERSION}

LABEL org.opencontainers.image.title="EpicMorg Vault"
LABEL org.opencontainers.image.description="HashiCorp Vault (release binary) on Debian trixie, drop-in for hashicorp/vault, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

# vault + the release's licence / notices; /emg-export for COPY --from
COPY --from=fetch /emg-export/ /
COPY --from=fetch /emg-export/ /emg-export/

ENV PATH="${EMG_VAULT_DIR}/bin:${PATH}"

# = hashicorp/vault: user vault, /vault/{config,file,logs}, setcap at start
# (libcap2-bin), ip (iproute2) for VAULT_*_INTERFACE, jq for scripts.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libcap2-bin iproute2 jq; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r vault; \
    useradd -r -g vault -d /vault -s /usr/sbin/nologin vault; \
    mkdir -p /vault/config /vault/file /vault/logs; \
    chown -R vault:vault /vault; \
    ln -s "${EMG_VAULT_DIR}/bin/vault" /bin/vault

COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    v="${EMG_VAULT_DIR}/bin/vault"; \
    [ "$(command -v vault)" = "$v" ] || { echo "FATAL: vault on PATH is $(command -v vault)" >&2; exit 1; }; \
    vault version | grep -q "^Vault v${EMG_VAULT_FULL_VERSION} " || { echo "FATAL: not Vault ${EMG_VAULT_FULL_VERSION}" >&2; vault version >&2; exit 1; }; \
    ! ldd "$v" >/dev/null 2>&1 || ! ldd "$v" | grep -q 'not found' || { echo "FATAL: vault has unresolved deps" >&2; exit 1; }; \
    echo "--- smoke test: dev server (root token, kv put/get), server with file storage (init, unseal, kv) ---"; \
    port_free() { ! grep -qi "^ *[0-9]*: [0-9A-F]*:$(printf %04X "$1") " /proc/net/tcp /proc/net/tcp6 2>/dev/null; }; \
    pick() { q=0; while [ "$q" = 0 ] || ! port_free "$q" || ! port_free $((q + 1)); do q="$(shuf -i 20000-59998 -n 1)"; done; echo "$q"; }; \
    t="$(mktemp -d)"; chmod 0777 "$t"; \
    p="$(pick)"; \
    VAULT_DEV_ROOT_TOKEN_ID=smoke VAULT_DEV_LISTEN_ADDRESS="127.0.0.1:$p" SKIP_SETCAP=1 \
      docker-entrypoint.sh server -dev -dev-no-store-token > "$t/dev.log" 2>&1 & \
    export VAULT_ADDR="http://127.0.0.1:$p"; \
    for i in $(seq 1 60); do VAULT_TOKEN=smoke vault status >/dev/null 2>&1 && break; sleep 0.5; done; \
    VAULT_TOKEN=smoke vault kv put -mount=secret smoke answer=42 >/dev/null || { echo "FATAL: dev server: kv put failed" >&2; cat "$t/dev.log" >&2; exit 1; }; \
    [ "$(VAULT_TOKEN=smoke vault kv get -mount=secret -field=answer smoke)" = 42 ] || { echo "FATAL: dev server: kv get" >&2; exit 1; }; \
    pid="$(grep -lx vault /proc/[0-9]*/comm | head -1)"; pid="${pid%/comm}"; \
    [ "$(stat -c %U "$pid")" = vault ] || { echo "FATAL: vault does not run as vault" >&2; exit 1; }; \
    kill "${pid#/proc/}"; for i in $(seq 1 30); do [ -e "$pid" ] || break; sleep 0.5; done; \
    p="$(pick)"; export VAULT_ADDR="http://127.0.0.1:$p"; \
    printf '{"storage":{"file":{"path":"%s/data"}},"listener":[{"tcp":{"address":"127.0.0.1:%s","tls_disable":true}}],"disable_mlock":true,"api_addr":"http://127.0.0.1:%s","cluster_addr":"http://127.0.0.1:%s"}' \
      "$t" "$p" "$p" "$((p + 1))" > "$t/local.json"; \
    VAULT_LOCAL_CONFIG="$(cat "$t/local.json")" SKIP_SETCAP=1 docker-entrypoint.sh server > "$t/srv.log" 2>&1 & \
    # vault status: 2 = sealed (up, not initialised yet)
    for i in $(seq 1 60); do rc=0; vault status >/dev/null 2>&1 || rc=$?; [ "$rc" = 2 ] && break; sleep 0.5; done; \
    vault operator init -key-shares=1 -key-threshold=1 -format=json > "$t/init.json" || { echo "FATAL: operator init failed" >&2; cat "$t/srv.log" >&2; exit 1; }; \
    vault operator unseal "$(jq -r '.unseal_keys_b64[0]' "$t/init.json")" >/dev/null || { echo "FATAL: unseal failed" >&2; exit 1; }; \
    export VAULT_TOKEN="$(jq -r '.root_token' "$t/init.json")"; \
    for i in $(seq 1 30); do vault secrets enable -path=kv kv-v2 >/dev/null 2>&1 && break; sleep 1; done; \
    vault kv put -mount=kv smoke answer=43 >/dev/null && [ "$(vault kv get -mount=kv -field=answer smoke)" = 43 ] \
      || { echo "FATAL: server mode: kv failed" >&2; cat "$t/srv.log" >&2; exit 1; }; \
    pid="$(grep -lx vault /proc/[0-9]*/comm | head -1)"; kill "$(basename "$(dirname "$pid")")"; sleep 2; \
    unset VAULT_TOKEN VAULT_ADDR; \
    rm -rf "$t" /vault/config/local.json; \
    vault version

VOLUME ["/vault/logs", "/vault/file"]
EXPOSE 8200

STOPSIGNAL SIGTERM
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
CMD ["server", "-dev"]
