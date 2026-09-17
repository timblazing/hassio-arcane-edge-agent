# Home Assistant add-on: Arcane Edge Agent

Connects a Home Assistant host to an [Arcane](https://getarcane.app) manager as
an edge environment, so you can manage this machine's Docker containers from
the Arcane UI.

Running the agent as an add-on instead of a hand-started `docker run` container
also clears the **"Unsupported system - Unsupported software"** warning that
Home Assistant shows when it finds containers it doesn't manage.

## Supported machines

`aarch64` (64-bit Raspberry Pi 3/4/5 and most Home Assistant systems) and
`amd64`. Home Assistant dropped 32-bit `armv7` support in 2025.12, so if your
Pi runs a 32-bit Home Assistant image the add-on will not appear in the store.

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on store**.
2. Open the three-dot menu in the top right and choose **Repositories**.
3. Add `https://github.com/timblazing/hassio-arcane-edge-agent` and select **Add**.
4. Find **Arcane Edge Agent** in the store and select **Install**.

## Configuration

In Arcane, create the edge environment first (**Environments → Add Environment
→ Edge Agent**) and copy the token it gives you.

Then fill in the add-on's **Configuration** tab:

| Option | Required | Description |
| --- | --- | --- |
| `manager_api_url` | yes | Your Arcane manager's address, reachable from this machine, e.g. `http://10.1.1.4:3552` |
| `agent_token` | yes | The `arc_...` token from the edge environment you created |
| `edge_transport` | no | `poll` (default) or `auto` |
| `log_level` | no | `info` by default; use `debug` when troubleshooting |

### Turn off Protection mode

The agent manages Docker containers, so it needs access to the Docker socket.
Home Assistant only passes it through when Protection mode is off:

**Settings → Add-ons → Arcane Edge Agent → three-dot menu → Protection mode** (off).

The add-on will stop with an explanatory message in the log if the socket
isn't available.

Then **Start** the add-on, and the environment turns online in Arcane.

## Replacing an existing container

If you already started `arcane-edge-agent` by hand, remove it so the two agents
don't both register:

```bash
docker rm -f arcane-edge-agent
```

Use a new edge environment (and token) for the add-on rather than reusing the
old container's, since agent identity is stored in the data volume you're
discarding.

## Notes

The add-on wraps the official `ghcr.io/getarcaneapp/agent` release binary; the
version number tracks the upstream Arcane release it ships. Agent state lives
in the add-on's config folder, so it survives updates and is captured in Home
Assistant backups.
