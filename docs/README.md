# Resonance UML

## Sources and implementation status

These diagrams were reconciled with `Resonance_Codex_Context.md` supplied by the project owner and the repository branches/PRs reviewed on 2026-11-24. The context describes the target project and suggestions; it is not evidence that every feature exists.

- [PR #25](https://github.com/G10BAL/team-project/pull/25), `feature/bot-setup`, merged into `main`: `bot/main.py`, environment loading, guild slash command sync, and `/ping`.
- [PR #26](https://github.com/G10BAL/team-project/pull/26), `database/initial-schema`, still open at review: `database/initial_structure.sql` and `database/schema.png`. The UML database diagram reproduces that SQL draft; it does not merge or change the other contributor's branch.
- [PR #27](https://github.com/G10BAL/team-project/pull/27), `feat/docker-uml`: Docker packaging and this documentation.

| Diagram | Editable source | Compiled PNG | Scope |
| --- | --- | --- | --- |
| Deployment | [architecture.puml](architecture.puml) | [architecture.png](architecture.png) | Compose, environment, mounts, runtime dependencies, Discord |
| Components | [components.puml](components.puml) | [components.png](components.png) | Current adapter and planned modules in one local application |
| Sequence | [bot-startup-sequence.puml](bot-startup-sequence.puml) | [bot-startup-sequence.png](bot-startup-sequence.png) | Existing startup, missing configuration, guild sync, and `/ping` |
| Database classes | [database-model.puml](database-model.puml) | [database-model.png](database-model.png) | All seven tables, foreign keys, constraints, and export view from PR #26 |

## Decisions and pending work

The container uses the actual entry point `python -m bot.main`, rather than the illustrative `main.py` from the context. Runtime storage is reserved at `/app/data`; user music is read-only at `/music`. No additional service or external database is introduced.

Playback, file discovery, persistence services, recommendation algorithms, and CSV export remain planned. The context proposes separate listening sessions/events, but PR #26 currently stores one track playback per `listening_sessions` row. The diagram preserves the SQL branch's current design. Listening attribution, accepted recommendation semantics, evaluation dataset, and SQLCipher driver/key handling remain team decisions. No optional ChromaDB dependency is added.

## Regenerate PNGs locally

Use Java and an official [PlantUML release JAR](https://github.com/plantuml/plantuml/releases). These PNGs were rendered with PlantUML **1.2026.10**. The diagrams use the bundled Smetana layout engine where needed, so Graphviz is not required. Rendering is local and does not upload diagrams to a web service.

```bash
bash scripts/render-uml.sh /absolute/path/to/plantuml-1.2026.10.jar
```

The script renders every `docs/*.puml` beside its source and exits with an error on invalid UML. Commit updated PNGs together with any source edits. Keep the downloaded JAR outside the repository.
