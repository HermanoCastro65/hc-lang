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

local function looks_like_function_definition(line)
    -- Must end with )
    if not line:match("%)$") then
        return false
    end

    -- Skip control structures
    if starts_with_control_keyword(line) then
        return false
    end

    -- Must start with something that looks like a type
    -- Example: int main(), void test(), char* foo()
    if line:match("^[%a_][%w_%s%*]*%s+[%a_][%w_]*%s*%b()$") then
        return true
    end

    return false
end

local function starts_struct_block(line)
    if line:match("^struct%s+[%w_]+$") then return true end
    if line:match("^enum%s+[%w_]+$") then return true end
    if line:match("^union%s+[%w_]+$") then return true end
    return false
end

local function should_skip_semicolon(line)
    local trimmed = trim(line)
    if starts_struct_block(trimmed) then return true end

    -- Skip lines ending with comma
    if trimmed:sub(-1) == "," then return true end
    if trimmed == "" then return true end
    if trimmed:match("^#") then return true end
    if trimmed == "{" or trimmed == "}" then return true end

    if starts_with_control_keyword(trimmed) then return true end
    if trimmed == "else" then return true end
    if trimmed == "do" then return true end

    if trimmed:match("^case .+:$") then return true end
    if trimmed:match("^default:$") then return true end

    if looks_like_function_definition(trimmed) then return true end

    if trimmed:sub(-1) == ";" then return true end

    return false
end

function semicolon_inserter.process(lines)
    local output = {}
    local i = 1
    local inside_typedef = false

    while i <= #lines do
        local line = lines[i]
        local trimmed = trim(line)

        -- Detect typedef struct start
        if trimmed:match("^typedef%s+struct%s+[%w_]+$") then
            inside_typedef = true
            table.insert(output, trimmed)
            i = i + 1
        elseif inside_typedef and trimmed == "}" then
            -- Next line is alias name
            local alias = trim(lines[i + 1] or "")
            table.insert(output, "} " .. alias .. ";")
            inside_typedef = false
            i = i + 2  -- skip alias line
        else
            if should_skip_semicolon(trimmed) then
                table.insert(output, line)
            else
                table.insert(output, line .. ";")
            end
            i = i + 1
        end
    end

    return output
end

return semicolon_inserter