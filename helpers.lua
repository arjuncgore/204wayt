local M = {}

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
