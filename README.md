# 204wayt
2048 in waywall

Demo Vid: https://femboy.beauty/VVqFkE

## Setup
### Clone 204wayt to waywall config directory
```bash
git clone https://github.com/arjuncgore/204wayt.git ~/.config/waywall/204wayt
```

### Import plugin to waywall config
```lua
-- rest of code

require("204wayt.init").setup(config, nil)
return config
```
Without any configuration, you move with WASD and start/stop the game with U

## Configuration

You can replace `nil` in the import code with a config table of the following format
```lua
-- rest of code

local cfg_2048 = {
    start_key = "U",
    keys = {
        { "u", "w" },
        { "d", "s" },
        { "l", "a" },
        { "r", "d" },
    },
    look = {
        x = 800,
        y = 100,
        size = 4,
        color = "#220022",
        color2 = "#FFFFFF"
    }
}

require("204wayt.init").setup(config, cfg_2048)
return config
```

> In `cfg_2048.keys`, make sure not to change `"u"`, `"d"`, `"l"`, `"r"`. Those are identifiers for the way the key you assign it moves the board.

