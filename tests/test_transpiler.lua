local transpiler = require("src.transpiler")

local input = "examples/hello.hc"
local output = "examples/hello.c"

transpiler.transpile(input, output)

print("Transpilation completed.")
print("Generated file: " .. output)