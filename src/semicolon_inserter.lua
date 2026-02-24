local semicolon_inserter = {}

local function trim(line)
    return line:match("^%s*(.-)%s*$")
end

local function starts_with_control_keyword(line)
    return line:match("^if%s*%b()$")
        or line:match("^for%s*%b()$")
        or line:match("^while%s*%b()$")
        or line:match("^switch%s*%b()$")
end

local function is_function_definition(line)
    -- Ends with ) and is not control structure
    if line:match("%)$") and not starts_with_control_keyword(line) then
        return true
    end
    return false
end

local function should_skip_semicolon(line)
    local trimmed = trim(line)

    -- Empty
    if trimmed == "" then return true end

    -- Preprocessor
    if trimmed:match("^#") then return true end

    -- Braces
    if trimmed == "{" or trimmed == "}" then return true end

    -- Control structures
    if starts_with_control_keyword(trimmed) then return true end

    if trimmed == "else" then return true end
    if trimmed == "do" then return true end

    -- Case/default
    if trimmed:match("^case .+:$") then return true end
    if trimmed:match("^default:$") then return true end

    -- Function definition
    if is_function_definition(trimmed) then return true end

    -- Already has ;
    if trimmed:sub(-1) == ";" then return true end

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