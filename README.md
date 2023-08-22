# Safe Entry Guard Mod for Project Zomboid

![SafeEntryGuard Logo](SEGlogo.png) 
## Disclaimer

:warning: **This mod is still under active development.** While we aim to ensure stability, you may encounter unforeseen issues or changes in functionality. Always backup your saves and game data before using. Feedback and bug reports are highly appreciated.

## Description

Safe Entry Guard provides a robust protection buffer for players upon their entry into the game. This is designed to ensure players have a short window of immunity from zombie attacks, especially during vulnerable moments when just logging in.

### **Key Features:**
1. **Dual-layer Protection**: Unlike many other safe login mods which solely rely on ghost/invisibility mechanics (often to their detriment), Safe Entry Guard engages two layers of security: player invisibility and disabling zombies from attacking.
   
2. **Dynamic Duration**: If a player moves during their protective window, the duration of protection will automatically adjust, providing a reduced timeframe based on a sandbox-set multiplier.
   
3. **Sandbox Customization**: Options are integrated directly into the game's sandbox settings, allowing server administrators or single-player users to fine-tune the mod's behavior to their preferences.

4. **Dedicated Logger**: With an in-built debugging logger, users can get varied levels of debugging and information logging, ensuring easy troubleshooting and status tracking.

## Installation

1. Download the Safe Entry Guard mod.
2. Place the mod files into your `Project Zomboid/mods/` directory.
3. Launch the game, go to mods, and enable "Safe Entry Guard".
4. Adjust sandbox settings as desired.

## Sandbox Options

- **Protection Duration**: Set the duration (in seconds) of protection after logging in or starting the game. This duration reduces upon player movement.

- **Movement Duration Multiplier**: Adjust the multiplier that's applied to the protection duration once the player moves. For instance, a value of 0.5 means the duration is halved upon movement.

- **Logger Verbosity Level**: Control the logging details. Ranges from 1 (DEBUG, most verbose) to 5 (CRITICAL, least verbose).

## Differences from Other Mods

Many safe login mods have tried using an invisibility or "ghost mode" mechanic. However, they've often fallen short due to unreliable implementations. Safe Entry Guard stands out by:

- Implementing two layers of protection for the player.
- Providing sandbox-adjustable parameters for customization.
- Including a dedicated debug logger to assist with troubleshooting or mod performance analysis.

## Credits

- **Author**: Hazy Lunar
- **Affiliation**: Modder for the Valhalla Community.
  
Special thanks to the Valhalla Community for their continuous support and feedback. 

For questions, suggestions, or collaborations, contact [Hazy Lunar](https://ko-fi.com/hazylunar).

**Support & Donations**: Hazy Lunar is open to mod commissions for a small fee under $50, depending on the mod size. Buy them a coffee [here](https://ko-fi.com/hazylunar).

