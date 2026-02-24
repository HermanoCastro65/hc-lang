local indent = require("src.indent")
local block_generator = require("src.block_generator")
local semicolon_inserter = require("src.semicolon_inserter")

local lines = {
    "#include <stdio.h>",
    "",
    "int main()",
    "    int x = 10",
    "    int y = 20",
    "    if (x > 5)",
    "        x++",
    "    else",
    "        x--",
    "    for (int i = 0; i < 5; i++)",
    "        printf(\"%d\", i)",
    "    while (x < y)",
    "        x++",
    "    switch (x)",
    "        case 1:",
    "            break",
    "        default:",
    "            break",
    "    return 0"
}

local tokens = indent.process(lines)
local blocks = block_generator.generate(tokens)
local final = semicolon_inserter.process(blocks)

print("===== GENERATED C CODE =====")
for _, line in ipairs(final) do
    print(line)
end