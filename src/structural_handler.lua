local structural_handler = {}

local function trim(line)
    return line:match("^%s*(.-)%s*$")
end

function structural_handler.process(lines)
    local output = {}
    local inside_enum = false
    local inside_typedef_enum = false
    local i = 1

    while i <= #lines do
        local line = lines[i]
        local t = trim(line)

        -- typedef enum Nome
        if t:match("^typedef%s+enum%s+[%w_]+$") then
            inside_enum = true
            inside_typedef_enum = true
            table.insert(output, line)
            i = i + 1

        -- enum Nome
        elseif t:match("^enum%s+[%w_]+$") then
            inside_enum = true
            table.insert(output, line)
            i = i + 1

        elseif t == "{" then
            table.insert(output, line)
            i = i + 1

        elseif t == "}" and inside_enum then
            if inside_typedef_enum then
                local alias = trim(lines[i + 1] or "")
                table.insert(output, "} " .. alias .. ";")
                inside_typedef_enum = false
                inside_enum = false
                i = i + 2 -- pula alias
            else
                table.insert(output, "};")
                inside_enum = false
                i = i + 1
            end

        elseif inside_enum then
            -- membros do enum usam vírgula
            table.insert(output, t .. ",")
            i = i + 1

        else
            table.insert(output, line)
            i = i + 1
        end
    end

    return output
end

return structural_handler