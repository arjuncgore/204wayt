-- ==== cfg
local eg_cfg = {
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
    },
    auto_restart = false,
}

-- ==== IMPORTS
local waywall = require("waywall")
local h = require("204wayt.helpers")

-- ==== INITS
local board = nil
local M = {}
local board_handle1 = nil
local board_handle2 = nil
local board_handle3 = nil
local board_handle4 = nil
GAME_ON = false
Board_text = ""

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

function Print_board(cfg)
    Board_text = ""

    for i = 1, 4 do
        Board_text = Board_text ..
            string.format(
                "\n\n%5s %5s %5s %5s",
                tostring(board[i][1]),
                tostring(board[i][2]),
                tostring(board[i][3]),
                tostring(board[i][4])
            )
    end


    if board_handle1 then
        board_handle1:close(); board_handle1 = nil
    end
    if board_handle2 then
        board_handle2:close(); board_handle2 = nil
    end
    if board_handle3 then
        board_handle3:close(); board_handle3 = nil
    end
    if board_handle4 then
        board_handle4:close(); board_handle4 = nil
    end

    print(Board_text)

    board_handle1 = waywall.text(Board_text, h.offset_look(cfg.look, 0, 0, cfg.look.color))
    board_handle2 = waywall.text(Board_text, h.offset_look(cfg.look, 2, 2, cfg.look.color))
    board_handle3 = waywall.text(Board_text, h.offset_look(cfg.look, 4, 4, cfg.look.color2))
    board_handle4 = waywall.text(Board_text, h.offset_look(cfg.look, 6, 6, cfg.look.color2))
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

function Move(direction, cfg, config)
    local save_board = h.copy_board(board)
    print(direction)
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

    if not h.boards_equal(save_board, board) then
        Random_Place()
        Print_board(cfg)

        if not h.Has_legal_moves(board) then
            print("GAME OVER")
            GAME_ON = false
            local game_over_text = waywall.text("\n\n\n\n\n\n\n\n\n\n         GAME OVER",
                h.offset_look(cfg.look, 0, 0, cfg.look.color, 3))
            waywall.sleep(3000)
            game_over_text:close()
            if board_handle1 then
                board_handle1:close(); board_handle1 = nil
            end
            if board_handle2 then
                board_handle2:close(); board_handle2 = nil
            end
            if board_handle3 then
                board_handle3:close(); board_handle3 = nil
            end
            if board_handle4 then
                board_handle4:close(); board_handle4 = nil
            end
            Board_text = ""

            if cfg.auto_restart then
                Start(config, cfg)
                waywall.sleep(3000)
                Start(config, cfg)
            end
        end
    end
end

-- ==== START GAME
function Start(config, cfg)
    if not GAME_ON then
        GAME_ON = true
        Clear_board()
        math.randomseed(os.time()); math.random(); math.random(); math.random();

        Random_Place()
        Random_Place()

        Print_board(cfg)
    else
        GAME_ON = false
        if board_handle1 then
            board_handle1:close(); board_handle1 = nil
        end
        if board_handle2 then
            board_handle2:close(); board_handle2 = nil
        end
        if board_handle3 then
            board_handle3:close(); board_handle3 = nil
        end
        if board_handle4 then
            board_handle4:close(); board_handle4 = nil
        end
        Board_text = ""
    end
end

function M.setup(config, cfg)
    if cfg == nil then cfg = eg_cfg end
    config.actions[cfg.start_key] = function()
        Start(config, cfg)
    end

    h.Movement_Actions(config, Move, cfg)
    -- Move("l")
end

return M
