# 204wayt

2048 in [waywall](https://github.com/tesselslate/waywall).

## Installation

1. [Install waywall](https://tesselslate.github.io/waywall/00_installation.html).
2. Copy `init.lua` to your waywall configuration directory:
   ```sh
   mkdir -p ~/.config/waywall
   cp init.lua ~/.config/waywall/init.lua
   ```

## Running

Launch waywall wrapping any application (e.g. a terminal):

```sh
waywall run -- xterm
```

The 2048 game overlay will appear in the top-left corner of the window.

## Controls

| Key | Action |
|-----|--------|
| Arrow keys | Move tiles |
| `R` | Start a new game |
| `C` | Continue playing after reaching 2048 |

## How It Works

The game is implemented entirely in Lua using the waywall scripting API:

- **Game logic** — standard 2048 rules on a 4×4 grid (tiles slide and merge, 90% chance of spawning a 2, 10% chance of a 4).
- **Display** — the board is rendered as a formatted text overlay via `waywall.text()`.  
  On every move the overlay is destroyed and recreated with the updated board state.
- **Input** — arrow keys are bound through `config.actions`; they are consumed by the overlay and not forwarded to the underlying application.
