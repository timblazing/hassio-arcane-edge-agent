# Home Assistant add-on: Arcane Edge Agent

Connects a Home Assistant machine to an [Arcane](https://getarcane.app) manager
as an edge environment, so you can manage this machine's Docker containers from
the Arcane UI.

Running the agent as an add-on rather than a hand-started container also clears
the **"Unsupported system - Unsupported software"** warning Home Assistant shows
when it finds containers it doesn't manage.

## Supported machines

`aarch64` (64-bit Raspberry Pi 3/4/5 and most Home Assistant systems) and
`amd64`. Home Assistant dropped 32-bit `armv7` support in 2025.12, so the
add-on will not appear in the store on a 32-bit install.

## Installation

1. Go to **Settings → Add-ons → Add-on store**.
2. Open the three-dot menu, top right, and choose **Repositories**.
3. Add `https://github.com/timblazing/hassio-arcane-edge-agent`, then **Add**.
4. Find **Arcane Edge Agent** in the store and select **Install**.

## Setup

**In Arcane**, create the edge environment first — **Environments → Add
Environment → Edge Agent** — and copy the `arc_...` token it gives you.

**Turn off Protection mode** for the add-on: three-dot menu → **Protection
mode**. The agent manages Docker containers, and Home Assistant only passes the
Docker socket through to an unprotected add-on. The add-on stops with an
explanatory message in its log if the socket is missing.

**Fill in the Configuration tab:**

| Option | Required | Description |
| --- | --- | --- |
| `manager_api_url` | yes | Your manager's address, as reachable from this machine, e.g. `http://10.1.1.4:3552` |
| `agent_token` | yes | The `arc_...` token from the edge environment |
| `edge_transport` | no | `poll` (default) or `auto` |
| `log_level` | no | `info` by default; `debug` when troubleshooting |
| `analytics` | no | Off by default; send anonymous usage data upstream |

Then **Start**. A healthy log ends with `Successfully paired agent with
manager`, and the environment turns online in Arcane.

## Replacing an existing container

If you already ran the agent by hand, remove it so the two don't both register.
This is also what clears the unsupported-software warning:

```bash
docker rm -f arcane-edge-agent
```

Pair the add-on with a **new** edge environment rather than reusing the old
container's token — agent identity lives in the data volume you're discarding.

## Notes

**Transport.** Keep `poll` unless you know the manager can open connections
back to this machine. The agent always dials out, so it works behind NAT and
firewalls.

**Stored data.** The agent's database, projects, templates and git checkouts
live in the add-on's `/data` folder, so they survive add-on updates and are
included in Home Assistant backups.

**Runtime user.** The agent normally drops to a non-root user inside a
container, which cannot write to the add-on's own data folder. The add-on pins
`PUID`/`PGID` to 0 for this reason; root is also what the Docker socket
requires.

**Versioning.** The add-on version tracks the upstream Arcane release it ships
(`2.12.0`), with a fourth number for add-on-only changes (`2.12.0.3`). The
agent binary is copied from the official `ghcr.io/getarcaneapp/agent` image at
build time, so nothing is downloaded when the add-on starts.

## Development

```bash
./scripts/bump-version.sh 2.13.0     # point at a new upstream release
./scripts/bump-version.sh 2.13.0 1   # add-on-only fix on top of 2.13.0
```

The script checks that the upstream image tag exists before pinning to it. A
weekly workflow opens an issue when a newer Arcane release appears.

## License

MIT. Arcane itself is a separate project with its own license.
