# Arcane Agent

Connects this Home Assistant machine to an [Arcane](https://getarcane.app)
manager as an agent, so you can manage its Docker containers from the Arcane
UI.

Running the agent as a Home Assistant app (formerly add-on) rather than a
hand-started container also clears the **"Unsupported system - Unsupported
software"** warning Home Assistant shows when it finds containers it doesn't
manage.

## Requirements

- An Arcane manager on **3.x**. Arcane 3 needs the manager and every agent on
  the same major version, so upgrade the manager before this app.
- A 64-bit Home Assistant install (`aarch64` or `amd64`).

## Setup

1. **In Arcane**, go to **Agents → Add Agent**, give it a name and copy the
   token it shows (`arc_...`). An enrollment token from **Agents → Enrollment
   Tokens** works too.
2. **Turn off Protection mode** on this app's **Info** tab. The agent manages
   Docker containers, and Home Assistant only passes the Docker socket through
   to an unprotected app. The app stops with an explanatory message in its log
   if the socket is missing.
3. **Fill in the Configuration tab** (below), then **Start**.

A healthy log shows `Successfully paired agent with manager` (or `Enrolled
agent with manager` for an enrollment token), and the agent turns online in
Arcane.

## Configuration

| Option | Required | Description |
| --- | --- | --- |
| `manager_api_url` | yes | Your manager's address, as reachable from this machine, e.g. `http://10.1.1.4:3552` |
| `agent_token` | yes | The `arc_...` token from Arcane |
| `agent_transport` | no | `auto` (default), `grpc` or `websocket` |
| `log_level` | no | `info` by default; `debug` when troubleshooting |
| `analytics` | no | Off by default; send Arcane's anonymous usage heartbeat |

**Transport.** The agent always dials out to the manager and opens no ports,
so it works behind NAT and firewalls. `auto` uses gRPC over the manager's
normal HTTP(S) port and falls back to WebSocket. Choose `websocket` if a
reverse proxy in front of the manager does not pass HTTP/2, or if
`manager_api_url` includes a path prefix.

## Upgrading from 2.x

Version 3.0.1.1 of this app moves to Arcane 3 settings. Nothing needs to be
re-entered:

- The manager URL and token carry over, and an existing agent token keeps
  working; the manager shows the same agent, now under **Agents**.
- The old `edge_transport` option is gone, along with Arcane's polling
  transport. The new `agent_transport` option defaults to `auto`.
- Arcane 3 can only upgrade a database last used by Arcane 2.17.1 or later. If
  this app skipped the 2.17.x releases, it moves the old database to
  `/data/arcane-v2-database-<date>` and starts with a fresh one. Projects,
  templates and git checkouts are kept; the agent pairs again with the same
  token.

## Replacing an existing container

If you already ran the agent by hand, remove it so the two don't both register.
This is also what clears the unsupported-software warning:

```bash
docker rm -f arcane-edge-agent
```

Pair the app with a **new** agent in Arcane rather than reusing the old
container's token. The agent's identity lives in the data volume you're
discarding.

## Notes

**Stored data.** The agent's database, projects, templates, git checkouts,
SSH known hosts and mTLS certificates live in this app's `/data` folder, so
they survive updates and are included in Home Assistant backups.

**Runtime user.** The agent normally drops to a non-root user inside a
container, which cannot write to the app's data folder. The app pins
`PUID`/`PGID` to 0 for this reason; root is also what the Docker socket
requires.

**Updates.** Home Assistant owns this app's container. Update the agent from
Home Assistant's update screen, not from Arcane's agent upgrade or **Update
all** actions, which try to replace the container themselves. You can still
use Arcane to manage the other containers and images on this machine.

**Versioning.** The app version tracks the Arcane release it ships (`3.0.1`),
with a fourth number for app-only changes (`3.0.1.1`). The agent binary is
copied from the official `ghcr.io/getarcaneapp/agent` image at build time, so
nothing is downloaded when the app starts.
