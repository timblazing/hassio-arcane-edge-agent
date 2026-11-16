# Home Assistant app: Arcane Agent

Connects a Home Assistant machine to an [Arcane](https://getarcane.app) manager
as an agent, so you can manage this machine's Docker containers from the
Arcane UI.

Running the agent as a Home Assistant app (formerly add-on) rather than a
hand-started container also clears the **"Unsupported system - Unsupported
software"** warning Home Assistant shows when it finds containers it doesn't
manage.

## Supported machines

`aarch64` (64-bit Raspberry Pi 3/4/5 and most Home Assistant systems) and
`amd64`. Home Assistant dropped 32-bit `armv7` support in 2025.12, so the app
will not appear in the store on a 32-bit install.

The app ships Arcane 3, so the Arcane manager must also be on 3.x.

## Installation

1. Go to **Settings → Apps → App store** (**Settings → Add-ons → Add-on store**
   before Home Assistant 2026.2).
2. Open the three-dot menu, top right, and choose **Repositories**.
3. Add `https://github.com/timblazing/hassio-arcane-edge-agent`, then **Add**.
4. Find **Arcane Agent** in the store and select **Install**.

Setup, configuration options and upgrade notes are in the app's
**Documentation** tab ([DOCS.md](arcane_edge_agent/DOCS.md)).

## Development

```bash
./scripts/bump-version.sh 3.0.2     # point at a new upstream release
./scripts/bump-version.sh 3.0.2 1   # app-only fix on top of 3.0.2
```

The script checks that the upstream image tag exists before pinning to it.
The Arcane version lives in `ARG ARCANE_VERSION` in the
[Dockerfile](arcane_edge_agent/Dockerfile); the app version in
[config.yaml](arcane_edge_agent/config.yaml).

A daily workflow ([upstream-check.yaml](.github/workflows/upstream-check.yaml))
picks up new stable Arcane releases within the same major version: it verifies
the agent image, bumps the app version, commits the change to `main`, and
dispatches the lint and image build workflows. Home Assistant then offers the
published version as an update. A new major release is never published
automatically; the workflow opens an issue instead, because major releases
rename settings (as 3.0 did). GitHub Actions must have permission to write to
`main` for automatic publishing.

Images are built with Home Assistant's
[builder actions](https://github.com/home-assistant/builder) on native amd64
and arm64 runners and pushed to
`ghcr.io/timblazing/hassio-arcane-edge-agent-{arch}`. Pull requests build
without pushing.

## License

MIT. Arcane itself is a separate project with its own license.
