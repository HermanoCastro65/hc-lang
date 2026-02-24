local transpiler = require("src.transpiler")

local function file_exists(name)
    local f = io.open(name, "r")
    if f then
        f:close()
        return true
    end
    return false
end

local function get_output_name(input)
    return input:gsub("%.hc$", ".c")
end

local function compile_and_run(c_file)
    local exe_name = c_file:gsub("%.c$", "")

    print("Compiling with GCC...")
    os.execute("gcc " .. c_file .. " -o " .. exe_name)

    print("Running executable...")
    os.execute(exe_name)
end

-- CLI Arguments
local input = arg[1]
local flag = arg[2]

if not input then
    print("Usage: lua bin/hc.lua <file.hc> [--run]")
    return
end

if not file_exists(input) then
    print("Error: File not found -> " .. input)
    return
end

local output = get_output_name(input)

print("Transpiling " .. input .. " -> " .. output)
transpiler.transpile(input, output)

print("Done.")

if flag == "--run" then
    compile_and_run(output)
end