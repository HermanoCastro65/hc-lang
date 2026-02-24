local indent = require("src.indent")
local block_generator = require("src.block_generator")
local structural_handler = require("src.structural_handler")
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

    -- 2. Indentation analysis
    local tokens = indent.process(lines)

    -- 3. Generate block structure
    local block_output = block_generator.generate(tokens)

    -- 4. Handle structural constructs (enum, struct, typedef, etc.)
    local structured_output = structural_handler.process(block_output)

    -- 5. Insert semicolons
    local final_output = semicolon_inserter.process(structured_output)

    -- 6. Write C output
    write_file(output_path, final_output)
end

return transpiler