local indent = require("src.indent")
local block_generator = require("src.block_generator")
local semicolon_inserter = require("src.semicolon_inserter")

local transpiler = {}

local function read_file(path)
    local lines = {}
    local file = io.open(path, "r")
    if not file then
        error("Could not open file: " .. path)
    end

    for line in file:lines() do
        table.insert(lines, line)
    end

    file:close()
    return lines
end

local function write_file(path, lines)
    local file = io.open(path, "w")
    if not file then
        error("Could not write file: " .. path)
    end

    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end

    file:close()
end

function transpiler.transpile(input_path, output_path)
    -- 1. Read HC source
    local lines = read_file(input_path)

    -- 2. Structural analysis
    local tokens = indent.process(lines)

    -- 3. Generate blocks
    local block_output = block_generator.generate(tokens)

    -- 4. Insert semicolons
    local final_output = semicolon_inserter.process(block_output)

    -- 5. Write C output
    write_file(output_path, final_output)
end

return transpiler