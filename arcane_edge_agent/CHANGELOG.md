# Changelog

## 2.12.0.3

- Keep projects, templates and git checkouts in `/data` alongside the database.
  They were going to the agent's default `/app/data`, inside the container's
  writable layer, so they were discarded on every add-on update.
- Add an `analytics` option, off by default. The agent's usage reporting is
  rate-limited upstream and logged a 429 error every few minutes.
- Warn when `manager_api_url` points at localhost, which is this add-on rather
  than the manager.
- Add `scripts/bump-version.sh` and a weekly check that opens an issue when a
  new Arcane release is out.

## 2.12.0.2

- Set `PUID`/`PGID` to 0. In a container the agent drops to its built-in
  non-root user (65532), which cannot write to `/data`, so it failed with
  "open /data/arcane.db: permission denied". Add-ons run as root, and root is
  what the Docker socket needs anyway.

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
