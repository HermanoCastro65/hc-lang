local transpiler = require("src.transpiler")

local function is_windows()
    return package.config:sub(1,1) == "\\"
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f then f:close() return true end
    return false
end

local function delete_file(path)
    os.remove(path)
end

local function compile_and_run(c_file)
    local exe_name = c_file:gsub("%.c$", "")
    local win = is_windows()

    if win then
        local exe_path = exe_name .. ".exe"
        os.execute('gcc "' .. c_file .. '" -o "' .. exe_path .. '"')
        os.execute('cmd /c ".\\' .. exe_path:gsub("/", "\\") .. '"')
        delete_file(exe_path)
    else
        os.execute('gcc "' .. c_file .. '" -o "' .. exe_name .. '"')
        os.execute('./' .. exe_name)
        delete_file(exe_name)
    end
end

local function run_single(file)
    print("\n==============================")
    print("Running: " .. file)
    print("==============================")

    local output = file:gsub("%.hc$", ".c")

    transpiler.transpile(file, output)
    compile_and_run(output)
    delete_file(output)
end

local function run_all_examples()
    local win = is_windows()
    local command

    if win then
        command = 'dir /b examples\\*.hc'
    else
        command = 'ls examples/*.hc'
    end

    local handle = io.popen(command)
    if not handle then
        print("Could not list example files.")
        return
    end

    for file in handle:lines() do
        local full_path = "examples/" .. file
        run_single(full_path)
    end

    handle:close()
end

-- CLI
local arg1 = arg[1]

if arg1 == "--all" then
    run_all_examples()
elseif arg1 and file_exists(arg1) then
    run_single(arg1)
else
    print("Usage:")
    print("  lua bin/hc.lua <file.hc>")
    print("  lua bin/hc.lua --all")
end