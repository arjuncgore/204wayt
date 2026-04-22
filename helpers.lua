local M = {}

function M.copy_board(src)
    local out = {}
    for i = 1, 4 do
        out[i] = {}
        for j = 1, 4 do
            out[i][j] = src[i][j]
        end
    end
    return out
end

function M.boards_equal(a, b)
    for i = 1, 4 do
        for j = 1, 4 do
            if a[i][j] ~= b[i][j] then
                return false
            end
        end
    end
    return true
end

function M.offset_look(look, dx, dy, color, depth)
    if depth == nil then depth = 2 end
    return {
        x = look.x + dx,
        y = look.y + dy,
        size = look.size,
        color = color,
        depth = depth
    }
end

function M.Has_legal_moves(board)
    for i = 1, 4 do
        for j = 1, 4 do
            if board[i][j] == "_" then
                return true
            end

            if j < 4 and board[i][j] == board[i][j + 1] then
                return true
            end

            if i < 4 and board[i][j] == board[i + 1][j] then
                return true
            end
        end
    end

    return false
end

function M.Movement_Actions(config, fn, cfg)
    for _, key in pairs(cfg.keys) do
        if config.actions[key[2]] ~= nil then
            local func = config.actions[key[2]]
            config.actions[key[2]] = function()
                if GAME_ON then
                    fn(key[1], cfg, config)
                    return false
                else
                    return func()
                end
            end
        else
            config.actions[key[2]] = function()
                if GAME_ON then
                    fn(key[1], cfg, config)
                    return false
                else
                    return false
                end
            end
        end
    end
end

function M.Compress_row_left(row, board)
    local vals = {}

    for j = 1, 4 do
        if board[row][j] ~= "_" then
            table.insert(vals, board[row][j])
        end
    end

    local merged = {}
    local j = 1

    while j <= #vals do
        if j < #vals and vals[j] == vals[j + 1] then
            table.insert(merged, vals[j] * 2)
            j = j + 2
        else
            table.insert(merged, vals[j])
            j = j + 1
        end
    end

    for col = 1, 4 do
        if col <= #merged then
            board[row][col] = merged[col]
        else
            board[row][col] = "_"
        end
    end
end

function M.Compress_row_right(row, board)
    local vals = {}

    for j = 4, 1, -1 do
        if board[row][j] ~= "_" then
            table.insert(vals, board[row][j])
        end
    end

    local merged = {}
    local j = 1

    while j <= #vals do
        if j < #vals and vals[j] == vals[j + 1] then
            table.insert(merged, vals[j] * 2)
            j = j + 2
        else
            table.insert(merged, vals[j])
            j = j + 1
        end
    end

    for col = 4, 1, -1 do
        local idx = 4 - col + 1
        if idx <= #merged then
            board[row][col] = merged[idx]
        else
            board[row][col] = "_"
        end
    end
end

function M.Compress_col_up(col, board)
    local vals = {}

    for i = 1, 4 do
        if board[i][col] ~= "_" then
            table.insert(vals, board[i][col])
        end
    end

    local merged = {}
    local j = 1

    while j <= #vals do
        if j < #vals and vals[j] == vals[j + 1] then
            table.insert(merged, vals[j] * 2)
            j = j + 2
        else
            table.insert(merged, vals[j])
            j = j + 1
        end
    end

    for row = 1, 4 do
        if row <= #merged then
            board[row][col] = merged[row]
        else
            board[row][col] = "_"
        end
    end
end

function M.Compress_col_down(col, board)
    local vals = {}

    for i = 4, 1, -1 do
        if board[i][col] ~= "_" then
            table.insert(vals, board[i][col])
        end
    end

    local merged = {}
    local j = 1

    while j <= #vals do
        if j < #vals and vals[j] == vals[j + 1] then
            table.insert(merged, vals[j] * 2)
            j = j + 2
        else
            table.insert(merged, vals[j])
            j = j + 1
        end
    end

    for row = 4, 1, -1 do
        local idx = 4 - row + 1
        if idx <= #merged then
            board[row][col] = merged[idx]
        else
            board[row][col] = "_"
        end
    end
end

return M
