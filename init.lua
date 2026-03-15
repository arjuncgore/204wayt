-- 2048 for waywall
-- Place this file at ~/.config/waywall/init.lua
-- Usage: waywall run -- <application>

local waywall = require("waywall")

math.randomseed(os.time())

-- =========================================================================
-- Game Logic
-- =========================================================================

local N = 4  -- board size (4x4)

local board = {}
local score = 0
local best = 0
local game_over = false
local game_won = false
local keep_playing = false

local function new_game()
    board = {}
    for r = 1, N do
        board[r] = {}
        for c = 1, N do board[r][c] = 0 end
    end
    score = 0
    game_over = false
    game_won = false
    keep_playing = false
end

local function empty_cells()
    local cells = {}
    for r = 1, N do
        for c = 1, N do
            if board[r][c] == 0 then cells[#cells + 1] = {r, c} end
        end
    end
    return cells
end

-- Spawn a new tile: 90% chance of 2, 10% chance of 4.
local function add_tile()
    local cells = empty_cells()
    if #cells == 0 then return end
    local pos = cells[math.random(#cells)]
    board[pos[1]][pos[2]] = math.random() < 0.9 and 2 or 4
end

-- Slide a line of tiles toward index 1, merging equal adjacent tiles.
-- i always advances by 1 regardless of a merge, so a freshly merged tile at
-- position i is never compared again (the next check starts at i+1), which
-- correctly prevents a single tile from participating in more than one merge
-- per move.
-- Returns the new line and the points scored.
local function slide(line)
    -- Remove zeros (compact).
    local t = {}
    for _, v in ipairs(line) do
        if v ~= 0 then t[#t + 1] = v end
    end
    -- Scan left-to-right; merge each adjacent equal pair at most once.
    local pts = 0
    local i = 1
    while i < #t do
        if t[i] == t[i + 1] then
            t[i] = t[i] * 2
            pts = pts + t[i]
            table.remove(t, i + 1)
        end
        i = i + 1
    end
    -- Pad with zeros.
    while #t < N do t[#t + 1] = 0 end
    return t, pts
end

-- Check whether any legal move remains on the board.
local function has_moves()
    for r = 1, N do
        for c = 1, N do
            if board[r][c] == 0 then return true end
            if r < N and board[r][c] == board[r + 1][c] then return true end
            if c < N and board[r][c] == board[r][c + 1] then return true end
        end
    end
    return false
end

-- Check whether the 2048 tile exists anywhere on the board.
local function has_2048()
    for r = 1, N do
        for c = 1, N do
            if board[r][c] == 2048 then return true end
        end
    end
    return false
end

-- Apply a move in the given direction ("left", "right", "up", "down").
-- Returns true if the board changed.
local function do_move(dir)
    if game_over or (game_won and not keep_playing) then return false end

    local changed = false
    local pts = 0

    if dir == "left" then
        for r = 1, N do
            local line = {}
            for c = 1, N do line[c] = board[r][c] end
            local nl, p = slide(line)
            pts = pts + p
            for c = 1, N do
                if board[r][c] ~= nl[c] then changed = true end
                board[r][c] = nl[c]
            end
        end
    elseif dir == "right" then
        for r = 1, N do
            -- Reverse row into line, slide, un-reverse.
            local line = {}
            for c = 1, N do line[N - c + 1] = board[r][c] end
            local nl, p = slide(line)
            pts = pts + p
            for c = 1, N do
                if board[r][c] ~= nl[N - c + 1] then changed = true end
                board[r][c] = nl[N - c + 1]
            end
        end
    elseif dir == "up" then
        for c = 1, N do
            local line = {}
            for r = 1, N do line[r] = board[r][c] end
            local nl, p = slide(line)
            pts = pts + p
            for r = 1, N do
                if board[r][c] ~= nl[r] then changed = true end
                board[r][c] = nl[r]
            end
        end
    elseif dir == "down" then
        for c = 1, N do
            -- Reverse column into line, slide, un-reverse.
            local line = {}
            for r = 1, N do line[N - r + 1] = board[r][c] end
            local nl, p = slide(line)
            pts = pts + p
            for r = 1, N do
                if board[r][c] ~= nl[N - r + 1] then changed = true end
                board[r][c] = nl[N - r + 1]
            end
        end
    end

    if changed then
        score = score + pts
        if score > best then best = score end
        add_tile()
        if not game_won and has_2048() then game_won = true end
        if not has_moves() then game_over = true end
    end

    return changed
end

-- =========================================================================
-- Display
-- =========================================================================

local display = nil

local function close_display()
    if display then
        display:close()
        display = nil
    end
end

-- Right-justify a cell value in a fixed-width field.
local function cell_str(v)
    if v == 0 then return "    " end
    local s = tostring(v)
    while #s < 4 do s = " " .. s end
    return s
end

-- Build the full game board as a single multi-line string.
local function render()
    local sep = "  +------+------+------+------+"
    local lines = {}

    -- Header line: title and scores.
    lines[#lines + 1] = string.format(
        "2048                SCORE: %-8d  BEST: %d", score, best
    )
    lines[#lines + 1] = ""

    -- Status line.
    if game_over then
        lines[#lines + 1] = "  *** GAME OVER ***   Press R to start a new game."
    elseif game_won and not keep_playing then
        lines[#lines + 1] = "  *** YOU WIN! ***    Press C to keep playing or R to restart."
    else
        lines[#lines + 1] = ""
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = sep

    for r = 1, N do
        local row = "  |"
        for c = 1, N do
            row = row .. " " .. cell_str(board[r][c]) .. " |"
        end
        lines[#lines + 1] = row
        lines[#lines + 1] = sep
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "  Arrow keys: move tiles     R: new game     C: continue after win"

    return table.concat(lines, "\n")
end

-- Destroy the current overlay and recreate it with the current board state.
local function refresh()
    close_display()
    display = waywall.text(render(), {
        x = 10,
        y = 10,
        size = 2,
        color = "#ffffffff",
    })
end

-- =========================================================================
-- Initialisation and key bindings
-- =========================================================================

local function start()
    new_game()
    add_tile()
    add_tile()
    refresh()
end

-- Restart the game display whenever the waywall configuration is (re)loaded.
waywall.listen("load", function()
    start()
end)

local config = {
    theme = {
        background = "#3f3f44ff",
    },
    actions = {
        ["Up"] = function()
            do_move("up")
            refresh()
        end,
        ["Down"] = function()
            do_move("down")
            refresh()
        end,
        ["Left"] = function()
            do_move("left")
            refresh()
        end,
        ["Right"] = function()
            do_move("right")
            refresh()
        end,
        ["r"] = function()
            start()
        end,
        ["c"] = function()
            if game_won and not keep_playing then
                keep_playing = true
                refresh()
            end
        end,
    },
}

return config
