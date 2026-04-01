-- ==== cfg
local eg_cfg = {

}

-- ==== IMPORTS
local waywall = require("waywall")
local h = require("204wayt.helpers")

-- ==== INITS
local board = nil
local M = {}
local board_handle = nil

-- ==== HELPERS
function Clear_board()
    board = {}
    for i = 1, 4 do
        board[i] = {}
        for j = 1, 4 do
            board[i][j] = "_"
        end
    end
end

function Print_board()
    local board_text = ""
    for i = 1, 4 do
        board_text = board_text .. "\n" .. board[i][1] .. " " .. board[i][2] .. " " .. board[i][3] .. " " .. board[i][4]
    end

    if board_handle then
        board_handle:close()
        board_handle = nil
    end

    print(board_text)

    board_handle = waywall.text(board_text, {
        x = 100,
        y = 100,
        size = 3,
        color = "#000000"
    })
end

function Random_Place()
    local free_spots = {}
    for i = 1, 4 do
        for j = 1, 4 do
            if board[i][j] == "_" then
                table.insert(free_spots, { row = i, col = j })
            end
        end
    end

    local spot = free_spots[math.random(#free_spots)]
    local place = 2
    if math.random() < 0.1 then
        place = 4
    end
    board[spot.row][spot.col] = place
end

function Move(direction)
    for i = 1, 4 do
        if direction == "l" then
            h.Compress_row_left(i, board)
        elseif direction == "r" then
            h.Compress_row_right(i, board)
        elseif direction == "u" then
            h.Compress_col_up(i, board)
        elseif direction == "d" then
            h.Compress_col_down(i, board)
        end
    end
end

-- ==== START GAME
function Start(config, cfg)
    Clear_board()
    math.randomseed(os.time()); math.random(); math.random(); math.random();

    Random_Place()
    Random_Place()

    config.actions["U"] = function()
        Print_board()
    end
end

function M.setup(config, cfg)
    Start(config, cfg)
end

return M
