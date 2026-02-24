local transpiler = require("src.transpiler")

local function is_windows()
    return package.config:sub(1,1) == "\\"
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f then f:close() return true end
    return false
end

local function ensure_generated_folder()
    local win = is_windows()
    if win then
        os.execute('if not exist examples\\generated mkdir examples\\generated')
    else
        os.execute('mkdir -p examples/generated')
    end
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

local function run_single(file, keepc)
    print("\n==============================")
    print("Running: " .. file)
    print("==============================")

    local output

    if keepc then
        ensure_generated_folder()
        local filename = file:match("([^/\\]+)%.hc$")
        output = "examples/generated/" .. filename .. ".c"
    else
        output = file:gsub("%.hc$", ".c")
    end

    transpiler.transpile(file, output)
    compile_and_run(output)

    if not keepc then
        delete_file(output)
    end
end

local function run_all_examples(keepc)
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
        run_single(full_path, keepc)
    end

    handle:close()
end

-- CLI parsing
local arg1 = arg[1]
local arg2 = arg[2]

local keepc = false

if arg1 == "--all" and arg2 == "--keepc" then
    keepc = true
    run_all_examples(true)

elseif arg1 == "--all" then
    run_all_examples(false)

elseif arg1 and file_exists(arg1) then
    run_single(arg1, false)

else
    print("Usage:")
    print("  lua bin/hc.lua <file.hc>")
    print("  lua bin/hc.lua --all")
    print("  lua bin/hc.lua --all --keepc")
end