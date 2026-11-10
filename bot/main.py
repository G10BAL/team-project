import os

import discord
from discord.ext import commands
from dotenv import load_dotenv


# Load environment variables
load_dotenv()

token = os.getenv("DISCORD_TOKEN")
guild_id = os.getenv("DISCORD_GUILD_ID")

if not token:
    raise RuntimeError("DISCORD_TOKEN is not set")

if not guild_id:
    raise RuntimeError("DISCORD_GUILD_ID is not set")


# Configure the bot
class ResonanceBot(commands.Bot):

    async def setup_hook(self):
        guild = discord.Object(id=int(guild_id))

        self.tree.copy_global_to(guild=guild)
        await self.tree.sync(guild=guild)

        print("Slash commands synchronized")


intents = discord.Intents.default()

bot = ResonanceBot(
    command_prefix="!",
    intents=intents
)


# Handle bot startup
@bot.event
async def on_ready():
    print(f"Logged in as {bot.user}")


# Register the ping command
@bot.tree.command(
    name="ping",
    description="Check if the bot is online"
)
async def ping(interaction: discord.Interaction):
    await interaction.response.send_message("Pong!")


# Start the bot
if __name__ == "__main__":
    bot.run(token)