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
    local is_windows = package.config:sub(1,1) == "\\"

    print("Compiling with GCC...")

    if is_windows then
        -- Converte / para \
        local exe_path = exe_name:gsub("/", "\\") .. ".exe"
        local c_path = c_file:gsub("/", "\\")

        os.execute('gcc "' .. c_path .. '" -o "' .. exe_path .. '"')

        print("Running executable...")
        os.execute('cmd /c "' .. exe_path .. '"')
    else
        os.execute('gcc "' .. c_file .. '" -o "' .. exe_name .. '"')
        print("Running executable...")
        os.execute('./' .. exe_name)
    end
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