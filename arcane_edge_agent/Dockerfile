# The agent ships as a single static Go binary, so we copy it straight out of
# the upstream image instead of downloading a release at build time.
ARG ARCANE_VERSION="2.12.0"
FROM ghcr.io/getarcaneapp/agent:v${ARCANE_VERSION} AS upstream

ARG BUILD_FROM
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=upstream /app/arcane-agent /usr/bin/arcane-agent

RUN chmod +x /usr/bin/arcane-agent \
    && /usr/bin/arcane-agent --version 2>/dev/null || true

COPY rootfs /

# s6 needs the service scripts executable regardless of the checkout's mode bits.
RUN chmod +x /etc/services.d/arcane-agent/run /etc/services.d/arcane-agent/finish

# Build metadata, populated by the HA builder.
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
