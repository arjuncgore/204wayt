-- ==== cfg
local eg_cfg = {

}

-- ==== IMPORTS
-- local waywall = require("waywall")
local h = require("204wayt.helpers")

-- ==== INITS
local board = nil
local M = {}

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
    for i = 1, 4 do
        print(board[i][1] .. " " .. board[i][2] .. " " .. board[i][3] .. " " .. board[i][4])
    end
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

    -- Print_board()
end

function M.setup(config, cfg)
    Start(config, cfg)
end

Start(nil, eg_cfg)

return M
