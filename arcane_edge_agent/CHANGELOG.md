# Changelog

## 3.1.1

- Update the bundled Arcane agent to v3.1.1. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v3.1.1).

## 3.1.0

- Update the bundled Arcane agent to v3.1.0. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v3.1.0).

## 3.0.1.1

- Fix the agent failing to start since 3.0.0. Arcane 3 renamed its settings to
  `ARCANE_`-prefixed names and refuses to start when it finds the old ones,
  which this app was still setting.
- Replace the `edge_transport` option with `agent_transport` (`auto`, `grpc`
  or `websocket`, default `auto`). Arcane 3 removed the polling transport;
  the agent still only dials out.
- If the stored database predates Arcane 2.17.1, which Arcane 3 cannot
  upgrade, move it to `/data/arcane-v2-database-<date>` and start fresh
  instead of failing. Projects, templates and git checkouts are kept.
- Keep SSH known hosts and agent mTLS certificates in `/data` so they survive
  updates.
- Map the `trace`, `notice` and `fatal` log levels to the nearest level Arcane
  understands instead of falling back to `info`.
- Rename the app to Arcane Agent, matching Arcane 3. The slug, image and
  stored settings are unchanged.
- Build on the Home Assistant Alpine 3.24 base image with the current
  Home Assistant builder actions, and move to the s6-overlay v3 service layout.
- Stop publishing new major Arcane releases automatically; open an issue
  instead so the app can be adapted first.

## 3.0.1

- Update the bundled Arcane agent to v3.0.1. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v3.0.1).

## 3.0.0

- Update the bundled Arcane agent to v3.0.0. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v3.0.0).

## 2.17.3

- Update the bundled Arcane agent to v2.17.3. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.17.3).

## 2.17.2

- Update the bundled Arcane agent to v2.17.2. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.17.2).

## 2.17.1

- Update the bundled Arcane agent to v2.17.1. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.17.1).

## 2.17.0

- Update the bundled Arcane agent to v2.17.0. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.17.0).

## 2.16.1

- Update the bundled Arcane agent to v2.16.1. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.16.1).

## 2.16.0

- Update the bundled Arcane agent to v2.16.0. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.16.0).

## 2.15.1

- Update the bundled Arcane agent to v2.15.1. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.15.1).

## 2.15.0

- Update the bundled Arcane agent to v2.15.0. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.15.0).

## 2.14.0

- Update the bundled Arcane agent to v2.14.0. [Upstream release notes](https://github.com/getarcaneapp/arcane/releases/tag/v2.14.0).

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
