# git pinned per Mesh major.minor(.patch) (vars/main.yml: mesh_git), see "Git" below
FROM ghcr.io/epicmorg/git:2.50 AS git
FROM ghcr.io/epicmorg/jdk:21
LABEL org.opencontainers.image.title="EpicMorg Bitbucket Mesh"
LABEL org.opencontainers.image.description="Atlassian Bitbucket Mesh by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ARG RELEASE=4.0.1
# Old releases (1.x, 2.5.0) are not on the download site, only in Atlassian's maven repo.
ARG DOWNLOAD_URL=https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-mesh-${RELEASE}.tar.gz
ARG DOWNLOAD_URL_MAVEN=https://packages.atlassian.com/mvn/maven-external/com/atlassian/bitbucket/mesh/mesh-distribution/${RELEASE}/mesh-distribution-${RELEASE}.tar.gz
ARG TEMP_ARCHIVE=/tmp/atlassian-bitbucket-mesh-${RELEASE}.tar.gz

##################################################################
#                   Setup
##################################################################
ENV RUN_USER=daemon
ENV RUN_GROUP=daemon

# https://confluence.atlassian.com/bitbucketserver/bitbucket-mesh-1128304351.html
ENV MESH_HOME=/var/atlassian/application-data/mesh
ENV MESH_INSTALL_DIR=/opt/atlassian/mesh

VOLUME ["${MESH_HOME}"]
WORKDIR $MESH_HOME

# Expose gRPC port
EXPOSE 7777

##################################################################
#                   Installing
##################################################################
RUN set -eux; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / -o ${TEMP_ARCHIVE} ${DOWNLOAD_URL} || { rm -f ${TEMP_ARCHIVE} ${TEMP_ARCHIVE}.aria2; \
    aria2c --conf-path=/usr/local/share/epicmorg/aria2/config/aria2.conf \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / -o ${TEMP_ARCHIVE} ${DOWNLOAD_URL_MAVEN}; } && \
    mkdir -p ${MESH_INSTALL_DIR} ${MESH_HOME} && \
    tar -xzf ${TEMP_ARCHIVE} --strip-components=1 --directory "${MESH_INSTALL_DIR}" && \
    test -x ${MESH_INSTALL_DIR}/bin/start-mesh.sh && \
    chown -R ${RUN_USER}:${RUN_GROUP} ${MESH_INSTALL_DIR} ${MESH_HOME} && \
    rm -fv ${TEMP_ARCHIVE}

##################################################################
#                   Git
##################################################################
# Mesh refuses to start with a git it does not support (bounds in its mesh-core jar);
# 4.0.1 takes git 2.50. The base ships the newest epicmorg/git: swap it for
# epicmorg/git:2.50 (+ the baked libs it links), drop the other git trees,
# relink /usr/bin and re-version the epicmorg-git placeholder so apt sees the real version.
COPY --from=git /emg-export/ /
RUN set -eux; \
    pin_dir="${EMG_LOCAL_BASE_DIR}/git/2.50"; \
    test -x "$pin_dir/bin/git"; \
    find "${EMG_LOCAL_BASE_DIR}/git" -mindepth 1 -maxdepth 1 -type d ! -path "$pin_dir" -exec rm -rf {} +; \
    find /usr/bin -maxdepth 1 -type l -lname "${EMG_LOCAL_BASE_DIR}/git/*" -delete; \
    for b in "$pin_dir"/bin/*; do ln -sfn "$b" "/usr/bin/$(basename "$b")"; done; \
    elfs="$(find "$pin_dir/bin" "$pin_dir/libexec/git-core" -type f -perm -u+x -exec sh -c 'file -b "$1" | grep -q ELF && echo "$1"' _ {} \;)"; \
    if for b in $elfs; do ldd "$b"; done | grep -q 'not found'; then echo "FATAL: unresolved git deps" >&2; exit 1; fi; \
    for b in $elfs; do [ "$(ldd "$b" | grep -c 'libssl\.so')" -le 1 ] || { echo "FATAL: two libssl in $b" >&2; exit 1; }; done; \
    if readelf -d "$pin_dir/bin/git" | grep -q RUNPATH; then echo "FATAL: RUNPATH in git" >&2; exit 1; fi; \
    gv="$(git --version | awk '{print $3}')"; \
    case "$gv" in 2.50|2.50.*) ;; *) echo "FATAL: git $gv is not 2.50" >&2; exit 1;; esac; \
    lv="$(git-lfs version | sed -E 's#^git-lfs/([0-9.]+).*#\1#')"; \
    d="$(mktemp -d)"; mkdir -p "$d/DEBIAN"; \
    printf '%s\n' \
      "Package: epicmorg-git" \
      "Version: 1:${gv}-epicmorg" \
      "Architecture: all" \
      "Maintainer: EpicMorg DevTeam <developer@epicm.org>" \
      "Section: vcs" \
      "Priority: optional" \
      "Provides: git (= 1:${gv}), git-core (= 1:${gv}), git-man (= 1:${gv}), git-email (= 1:${gv}), git-cvs (= 1:${gv}), git-doc (= 1:${gv}), git-lfs (= ${lv})" \
      "Conflicts: git, git-core, git-man, git-email, git-cvs, git-doc, git-lfs" \
      "Replaces: git, git-core, git-man, git-email, git-cvs, git-doc, git-lfs" \
      "Description: git ${gv} + git-lfs ${lv} from epicmorg/git and epicmorg/git-lfs" \
      " Placeholder: git pinned for Bitbucket Mesh 4.0.1; binaries live in ${EMG_LOCAL_BASE_DIR}." \
      > "$d/DEBIAN/control"; \
    dpkg-deb --build "$d" /tmp/epicmorg-git.deb; \
    dpkg -i /tmp/epicmorg-git.deb; \
    rm -rf "$d" /tmp/epicmorg-git.deb; \
    test "$(dpkg-query -W -f='${Version}' epicmorg-git)" = "1:${gv}-epicmorg"; \
    git-lfs install --skip-repo --system --force; \
    echo "=============================================" && \
    echo git $(git --version) && \
    echo git-lfs $(git-lfs --version) && \
    echo "============================================="

# the release's own bounds must accept the pinned git (fails when mesh_git is wrong)
COPY mesh-git.sh /tmp/mesh-git.sh
RUN bash /tmp/mesh-git.sh && \
    rm -f /tmp/mesh-git.sh

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/usr/bin/tini", "--"]
