#!/usr/bin/env bash
# ==============================================================================
# Point the add-on at a different upstream Arcane release.
#
#   ./scripts/bump-version.sh 2.13.0        -> add-on 2.13.0
#   ./scripts/bump-version.sh 2.13.0 1      -> add-on 2.13.0.1 (add-on-only fix)
#
# The add-on version tracks the upstream release it ships, with a fourth number
# for changes to the add-on itself.
# ==============================================================================
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <arcane-version> [addon-revision]" >&2
    exit 1
fi

arcane_version="${1#v}"
addon_revision="${2:-}"

if [[ ! "${arcane_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: '${arcane_version}' is not a version like 2.13.0" >&2
    exit 1
fi

addon_version="${arcane_version}"
if [[ -n "${addon_revision}" ]]; then
    addon_version="${arcane_version}.${addon_revision}"
fi

# Confirm the upstream image really has this tag before pinning to it.
if command -v curl >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
    echo "Checking that ghcr.io/getarcaneapp/agent:v${arcane_version} exists..."
    token="$(curl -fsS "https://ghcr.io/token?scope=repository:getarcaneapp/agent:pull&service=ghcr.io" \
        | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')"
    status="$(curl -s -o /dev/null -w '%{http_code}' \
        -H "Authorization: Bearer ${token}" \
        -H 'Accept: application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json' \
        "https://ghcr.io/v2/getarcaneapp/agent/manifests/v${arcane_version}")"
    if [[ "${status}" != "200" ]]; then
        echo "ERROR: ghcr.io/getarcaneapp/agent:v${arcane_version} returned HTTP ${status}" >&2
        echo "Check the tag at https://github.com/getarcaneapp/arcane/releases" >&2
        exit 1
    fi
    echo "Found it."
fi

sed -i.bak -E "s/^version: \".*\"$/version: \"${addon_version}\"/" arcane_edge_agent/config.yaml
sed -i.bak -E "s/^ARG ARCANE_VERSION=\".*\"$/ARG ARCANE_VERSION=\"${arcane_version}\"/" arcane_edge_agent/Dockerfile
sed -i.bak -E "s/^  ARCANE_VERSION: \".*\"$/  ARCANE_VERSION: \"${arcane_version}\"/" arcane_edge_agent/build.yaml
rm -f arcane_edge_agent/*.bak

echo
echo "Add-on version: ${addon_version}"
echo "Arcane version: ${arcane_version}"
echo
echo "Now add a CHANGELOG.md entry, then commit and push."
