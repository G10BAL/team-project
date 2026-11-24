# Resonance

A Discord music bot built with Python, designed for local music playback and personalized recommendations.

## Current Features

- Discord bot initialization
- Slash command registration
- `/ping` command
- Environment-based configuration

## Requirements

- Python 3.12 (used by the Docker image)
- Discord bot token

## Installation

Clone the repository:

```bash
git clone https://github.com/G10BAL/team-project.git
cd team-project
```

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

## Configuration

Create a local environment file:

```bash
cp .env.example .env
```

Set the following variables:

- `DISCORD_TOKEN` — Discord bot token
- `DISCORD_GUILD_ID` — Test Discord server ID

Never commit your `.env` file.

## Running

```bash
python -m bot.main
```

## Running with Docker

Requires Docker Engine and Docker Compose v2. Create `.env` from `.env.example` and set a real `DISCORD_TOKEN` and numeric `DISCORD_GUILD_ID`. Never commit `.env`.

```bash
cp .env.example .env
mkdir -p music
# Edit .env before starting the bot.
docker compose up --build -d
docker compose logs -f bot
```

Use `MUSIC_DIRECTORY` in `.env` to select an existing host directory (default `./music`). It is mounted at `/music` read-only; the unprivileged container user needs read/traverse permission. Compose deliberately fails if the directory does not exist. No published ports or host sound device are required: the bot connects outbound to Discord. Voice playback, once implemented, also needs outbound UDP access.

The image includes Python 3.12, `discord.py` voice dependencies, FFmpeg, and Opus. These prepare the runtime for playback; current commands still only implement `/ping`.

The named volume `resonance-data` reserves writable `/app/data` for persistent local database/index files. The current bot does not read `/music`, create a database, or use this storage yet. Database integration must explicitly use `/app/data` and store catalogue paths under `/music`. SQLCipher and encryption key handling have not been implemented; the volume alone does not encrypt data.

```bash
docker compose stop       # stop, retaining containers and data
docker compose down       # remove containers, retain the named data volume
docker compose up --build -d  # rebuild after source/dependency changes
```

`docker compose down --volumes` deletes the stored data volume. Back it up before using that option. `.dockerignore` excludes secrets, local music, databases, and build caches from the image build context. Application code is copied into the image, so source changes need a rebuild.

## Architecture diagrams

See [diagram documentation](docs/README.md) for implementation status, links to the reviewed PRs, and local rendering instructions. Both editable PlantUML sources and compiled PNGs are committed:

- [Deployment PNG](docs/architecture.png) / [source](docs/architecture.puml)
- [Modules PNG](docs/components.png) / [source](docs/components.puml)
- [Startup and `/ping` PNG](docs/bot-startup-sequence.png) / [source](docs/bot-startup-sequence.puml)
- [Database UML PNG](docs/database-model.png) / [source](docs/database-model.puml)

## Commands

| Command | Description |
|---|---|
| `/ping` | Check if the bot is online |

## Development

The project is developed using feature branches and Pull Requests.
