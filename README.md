# Safe Entry Guard Mod for Project Zomboid

![SafeEntryGuard Logo](SEGlogo.png)

## Table of Contents

- [Disclaimer](#disclaimer)
- [Description](#description)
- [Installation](#installation)
- [Sandbox Options](#sandbox-options)
- [Differences from Other Mods](#differences-from-other-mods)
- [Credits](#credits)
- [License: Fair Use & Agreement](#license-fair-use--agreement)

## Disclaimer

:warning: **This mod is still under active development.** While we strive to provide stability, users may still encounter unforeseen issues or variations in functionality. It's advised to backup your saves and game data prior to use. Your feedback and bug reports are invaluable to us.

## Description

The Safe Entry Guard Mod ensures players have a buffer of protection when initiating the game, granting a moment to acclimate before potentially confronting a zombie onslaught. **This mod features built-in Multi-Version Support, fully optimized for Build 42 while retaining 100% legacy compatibility with Build 41.**

### **Key Features:**

1. **Quadruple-layer Protection**: Safe Entry Guard goes above and beyond by offering four layers of security: player invisibility, preventing zombies from attacking, Ghost Mode, and God Mode.

2. **Dynamic Duration**: The protection period dynamically reduces to a lower threshold when the player actually moves away from their spawn location.

3. **Combat Cancellation**: To prevent exploitation, if a player initiates an attack while under protection, their shield is instantly revoked.

4. **Split-Screen & Co-Op Friendly**: Seamlessly tracks individual protection states for up to 4 local split-screen players independently.

5. **Multi-Version Support**: Employs an intelligent folder structure to automatically load the correct, optimized code whether your server is running Build 41 or Build 42.

6. **Sandbox Customization**: A seamless integration into the game's sandbox options, letting server admins and players dictate the mod's behavior to suit their gameplay style.

## Installation

1. Secure a copy of the Safe Entry Guard mod.
2. Transfer the mod contents into the `Project Zomboid/mods/` directory.
3. Fire up the game, venture to mods, and activate "Safe Entry Guard".
4. Adjust sandbox settings as per your requirements.

## Sandbox Options

- **Protection Duration**: Designate the protective period (in seconds) upon game entry. This time frame reduces if the player decides to move.

- **Protection Duration After Movement**: The reduced duration (in seconds) of protection applied immediately after a player moves from their starting spawn location.

- **Use Invisibility**: Option to trigger the invisibility feature throughout the protection phase.

- **Use Zombies Don't Attack**: Option to ensure zombies actively ignore the player for the duration of the protection phase.

- **Use Ghost Mode**: Option to grant players Ghost Mode (allowing them to pass through zombies without collision).

- **Use God Mode**: Option to grant players complete invulnerability against the environment and other players.

## Differences from Other Mods

While many mods utilize invisibility or a "ghost mode", they often falter due to irregular executions. Safe Entry Guard sets itself apart by:

- Providing a robust **quadruple-layered** defense mechanism.
- Utilizing advanced spatial distance math to prevent micro-movements (like breathing animations or loading shifts) from falsely triggering the movement penalty.
- Operating on an independent, encapsulated state tracker to prevent variable conflicts with other mods and fully support local co-op.
- Implementing combat cancellation to prevent players from freely attacking zombies while invulnerable.
- Throttling UI text updates to preserve client frame rates.

## Credits

- **Author**: Stormbox
- **Affiliation**: A prominent contributor and adept modder under the banner of the Deathscape Community.
  
Sincere thanks to the Deathscape Community for their undying support and invaluable feedback.

For any queries, propositions, or potential partnerships, reach out to [Stormbox's GitHub](https://github.com/Stormiebox).

**Support & Donations**: Stand by Hazy Lunar. They're up for mod commissions at a reasonable fee under $50, contingent on the mod's intricacy. Extend your support [here](https://ko-fi.com/stormboxoriginal).

## License: Fair Use & Agreement

"Safe Entry Guard" mod stands as open-source software, available to all for use, adapt, and distribution. Should you decide to employ or cite this mod in your endeavors:

1. **Offer Credit**: Attribute "Safe Entry Guard" as the genesis and render due recognition to its creator, Stormbox.
  
2. **Provide Links**: Incorporate links to the foundational GitHub repository: [Stormbox's GitHub](https://github.com/Stormiebox) and its Steam Workshop Collection: [Safe Entry Guard on Steam Workshop](https://steamcommunity.com/workshop/filedetails/?id=3018173209).

By opting to use or reference this mod, you commit to the aforestated citations. While this isn't a binding legal requisite, it stands as a testament to goodwill and homage to the dedication and time expended by the original developer.
