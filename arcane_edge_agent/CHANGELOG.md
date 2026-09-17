# Changelog

## 2.12.0

First release.

- Runs the Arcane edge agent (v2.12.0) as a Home Assistant add-on.
- `MANAGER_API_URL` and `AGENT_TOKEN` are set from the add-on configuration
  screen instead of a hand-written `docker run` command.
- Agent state is stored in the add-on's config folder, so it survives updates
  and is included in Home Assistant backups.
