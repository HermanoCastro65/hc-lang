local indent = require("src.indent")
local block_generator = require("src.block_generator")

local lines = {
    "int main()",
    "    int x = 10",
    "    if (x > 5)",
    "        x++",
    "    return 0"
}

local tokens = indent.process(lines)
local output = block_generator.generate(tokens)

for _, line in ipairs(output) do
    print(line)
end