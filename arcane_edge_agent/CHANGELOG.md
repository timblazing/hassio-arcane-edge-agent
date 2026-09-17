# Changelog

## 2.12.0.1

- Store the agent database in `/data` instead of `/config`. `/config` is not
  writable for this add-on, so the agent failed to start with
  "open /config/arcane.db: permission denied".
- Rewrite the service `finish` script: it used `s6-test`, which s6-overlay v3
  no longer ships, so every restart logged "unable to spawn s6-test".

## 2.12.0

First release.

- Runs the Arcane edge agent (v2.12.0) as a Home Assistant add-on.
- `MANAGER_API_URL` and `AGENT_TOKEN` are set from the add-on configuration
  screen instead of a hand-written `docker run` command.
- Agent state is stored in the add-on's config folder, so it survives updates
  and is included in Home Assistant backups.
