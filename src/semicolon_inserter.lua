-- src/semicolon_inserter.lua

local semicolon_inserter = {}

local function should_skip_semicolon(line)
    local trimmed = line:match("^%s*(.-)%s*$")

    -- Skip empty lines
    if trimmed == "" then
        return true
    end

    -- Skip preprocessor
    if trimmed:match("^#") then
        return true
    end

    -- Skip block delimiters
    if trimmed == "{" or trimmed == "}" then
        return true
    end

    -- Skip control structures
    if trimmed:match("^if%s*%b()$") then return true end
    if trimmed:match("^for%s*%b()$") then return true end
    if trimmed:match("^while%s*%b()$") then return true end
    if trimmed:match("^switch%s*%b()$") then return true end
    if trimmed == "else" then return true end
    if trimmed == "do" then return true end

    -- Skip case/default
    if trimmed:match("^case .+:$") then return true end
    if trimmed:match("^default:$") then return true end

    -- Already has semicolon
    if trimmed:sub(-1) == ";" then
        return true
    end

    return false
end

function semicolon_inserter.process(lines)
    local output = {}

    for _, line in ipairs(lines) do
        if should_skip_semicolon(line) then
            table.insert(output, line)
        else
            table.insert(output, line .. ";")
        end
    end

    return output
end

return semicolon_inserter