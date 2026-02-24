local block_generator = {}

function block_generator.generate(tokens)
    local output = {}

    for _, token in ipairs(tokens) do
        if token.type == "INDENT" then
            table.insert(output, "{")
        elseif token.type == "DEDENT" then
            table.insert(output, "}")
        elseif token.type == "LINE" then
            table.insert(output, token.value)
        end
    end

    return output
end

return block_generator