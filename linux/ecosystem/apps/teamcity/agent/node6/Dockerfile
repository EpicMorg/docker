##################################################################
#        Node.js runtime: the prebuilt epicmorg/nodejs image (ADR-045)
##################################################################
# All node* agents share this file; they differ only in the version.
# pnpm / yarn come with the nodejs image (installed there as global npm
# packages, i.e. inside ${NODE_DIR}).
FROM docker.io/epicmorg/nodejs:6 AS node

FROM docker.io/epicmorg/teamcity-agent:minimal
ARG DEBIAN_FRONTEND=noninteractive

ENV NODE_DIR=${EMG_LOCAL_BASE_DIR}/nodejs/6
ENV PATH=${NODE_DIR}/bin:${PATH}

RUN groupadd -g 1337 node && \
    useradd  -u 1337 --gid node --shell /bin/bash --create-home node

COPY --from=node ${NODE_DIR}/ ${NODE_DIR}/

# Same /usr/local/bin symlinks the nodejs image has (node, npm, npx,
# corepack, pnpm, yarn ... whatever is in ${NODE_DIR}/bin). Fatal checks.
RUN set -eu; \
    for b in ${NODE_DIR}/bin/*; do ln -sfn "$b" /usr/local/bin/; done; \
    [ "$(readlink -f "$(command -v node)")" = "${NODE_DIR}/bin/node" ] || { echo "FATAL: node on PATH is not from ${NODE_DIR}" >&2; exit 1; }; \
    [ "$(readlink -f /usr/local/bin/node)" = "${NODE_DIR}/bin/node" ] || { echo "FATAL: /usr/local/bin/node is not from ${NODE_DIR}" >&2; exit 1; }; \
    case "$(node --version)" in v6.*) ;; *) echo "FATAL: node is $(node --version), expected v6.x" >&2; exit 1 ;; esac; \
    echo "node $(node --version)"; \
    echo "npm $(npm --version)"; \
    for t in pnpm yarn; do \
      if [ -e "${NODE_DIR}/bin/$t" ]; then echo "$t $($t --version)"; fi; \
    done

##################################################################
#                   final config
##################################################################
WORKDIR ${AGENT_DIST}
