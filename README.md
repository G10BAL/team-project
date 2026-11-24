# Resonance

A Discord music bot built with Python, designed for local music playback and personalized recommendations.

## Current Features

- Discord bot initialization
- Slash command registration
- `/ping` command
- Environment-based configuration

## Requirements

- Python 3.10+
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

Create `.env` from the example and set `DISCORD_TOKEN` and `DISCORD_GUILD_ID` as described above. Then build and start the bot:

```bash
docker compose up --build -d
```

View logs with `docker compose logs -f bot` and stop the bot with `docker compose down`. Compose reads `.env` into the container; `.dockerignore` keeps local environment files out of the image build context. The container runs as an unprivileged user.

## Architecture diagrams

PlantUML source diagrams are in [`docs/architecture.puml`](docs/architecture.puml) (deployment) and [`docs/bot-startup-sequence.puml`](docs/bot-startup-sequence.puml) (startup, command synchronization, and `/ping` interaction).

## Commands

| Command | Description |
|---|---|
| `/ping` | Check if the bot is online |

## Development

The project is developed using feature branches and Pull Requests.
