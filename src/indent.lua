local indent = {}

local function get_indent_level(line)
    return line:match("^%s*"):len()
end

local function strip_indent(line)
    return line:match("^%s*(.*)$")
end

function indent.process(lines)
    local tokens = {}
    local indent_stack = {0}

    for line_number, line in ipairs(lines) do
        local content = strip_indent(line)

        -- Ignorar linhas vazias SEM usar goto
        if content ~= "" then
            local current_indent = get_indent_level(line)
            local previous_indent = indent_stack[#indent_stack]

            -- INDENT
            if current_indent > previous_indent then
                table.insert(indent_stack, current_indent)
                table.insert(tokens, { type = "INDENT", line = line_number })
            end

            -- DEDENT
            while current_indent < indent_stack[#indent_stack] do
                table.remove(indent_stack)
                table.insert(tokens, { type = "DEDENT", line = line_number })
            end

            -- LINE
            table.insert(tokens, {
                type = "LINE",
                value = content,
                line = line_number
            })
        end
    end

    -- Fechar blocos restantes no final do arquivo
    while #indent_stack > 1 do
        table.remove(indent_stack)
        table.insert(tokens, { type = "DEDENT" })
    end

    return tokens
end

return indent