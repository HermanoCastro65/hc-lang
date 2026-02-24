local indent = require("src.indent")

local lines = {
    "int main()",
    "    int x = 10",
    "    if (x > 5)",
    "        x++",
    "    return 0"
}

local tokens = indent.process(lines)

for _, token in ipairs(tokens) do
    if token.type == "LINE" then
        print(token.type, token.value, "line:", token.line)
    else
        print(token.type, "line:", token.line)
    end
end