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
    -- termina com ) e não é controle
    if line:match("%)$") and not starts_with_control_keyword(line) then
        -- tem pelo menos dois identificadores antes do ()
        if line:match("^[%w_%*%s]+%s+[%w_]+%s*%b()$") then
            return true
        end
    end
    return false
end

local function is_struct_start(line)
    return line:match("^struct%s+[%w_]+$")
        or line:match("^enum%s+[%w_]+$")
        or line:match("^union%s+[%w_]+$")
end

local function is_typedef_struct_start(line)
    return line:match("^typedef%s+struct%s+[%w_]+$")
end

local function should_skip_semicolon(line)
    local t = trim(line)

    if t == "" then return true end
    if t:match("^#") then return true end
    if t == "{" or t == "}" then return true end

    if starts_with_control_keyword(t) then return true end
    if t == "else" then return true end
    if t == "do" then return true end

    -- DEFINIÇÕES ESTRUTURAIS (NÃO PODE TER ;)
    if t:match("^struct%s+[%w_]+$") then return true end
    if t:match("^enum%s+[%w_]+$") then return true end
    if t:match("^union%s+[%w_]+$") then return true end
    if t:match("^typedef%s+struct%s+[%w_]+$") then return true end
    if t:match("^typedef%s+enum%s+[%w_]+$") then return true end
    if t:match("^typedef%s+union%s+[%w_]+$") then return true end

    if looks_like_function_definition(t) then return true end

    if t:sub(-1) == "," then return true end
    if t:sub(-1) == ";" then return true end
    if t:sub(-1) == ":" then return true end

    return false
end

function semicolon_inserter.process(lines)
    local output = {}

    for i, line in ipairs(lines) do
        local t = trim(line)
        local prev = trim(output[#output] or "")

        -- corrigir case
        if t:match("^case .+") and not t:match(":$") then
            line = line .. ":"
            t = trim(line)
        end

        -- corrigir default
        if t == "default" then
            line = line .. ":"
            t = trim(line)
        end

        -- DO-WHILE special case
        if t:match("^while%s*%b()$") and prev == "}" then
            table.insert(output, line .. ";")

        elseif should_skip_semicolon(line) then
            table.insert(output, line)

        else
            table.insert(output, line .. ";")
        end
    end

    return output
end

return semicolon_inserter