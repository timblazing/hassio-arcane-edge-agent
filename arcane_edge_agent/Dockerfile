# The agent ships as a single static Go binary, so we copy it straight out of
# the upstream image instead of downloading a release at build time.
#
# Both ARGs are declared before the first FROM so they are global, and
# re-declared inside the stage that uses them, which is what Docker requires.
# Supervisor no longer passes BUILD_FROM, so it needs a default.
ARG BUILD_FROM=ghcr.io/home-assistant/base:3.24
ARG ARCANE_VERSION="3.1.0"

FROM ghcr.io/getarcaneapp/agent:v${ARCANE_VERSION} AS upstream

FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# sqlite reads the database's schema version at startup so the run script can
# spot a database too old for Arcane 3 to upgrade.
# hadolint ignore=DL3018
RUN apk add --no-cache sqlite

COPY --from=upstream /app/arcane-agent /usr/bin/arcane-agent
COPY rootfs /

# Some agent paths are fixed to /app/data rather than configurable (SSH
# known_hosts for git, agent mTLS certificates), so point that at the app's
# persistent /data folder as well. The agent has no --version flag, so nothing
# here runs it; doing so would start the server during the build.
RUN mkdir -p /app \
    && ln -s /data /app/data \
    && chmod +x /usr/bin/arcane-agent \
        /etc/s6-overlay/s6-rc.d/arcane-agent/run \
        /etc/s6-overlay/s6-rc.d/arcane-agent/finish

LABEL \
    io.hass.type="app" \
    org.opencontainers.image.title="Arcane Agent" \
    org.opencontainers.image.description="Manage this machine's Docker containers from an Arcane manager" \
    org.opencontainers.image.licenses="MIT"
