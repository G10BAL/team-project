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

## Commands

| Command | Description |
|---|---|
| `/ping` | Check if the bot is online |

## Development

The project is developed using feature branches and Pull Requests.