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
    if is_windows() then
        os.execute('if not exist examples\\generated mkdir examples\\generated')
    else
        os.execute('mkdir -p examples/generated')
    end
end

local function delete_file(path)
    os.remove(path)
end

local function compile_and_run(c_file)
    local exe_base = c_file:gsub("%.c$", "")
    local win = is_windows()

    if win then
        local exe_path = exe_base .. ".exe"
        local exe_run_path = ".\\" .. exe_path:gsub("/", "\\")
        os.execute('gcc "' .. c_file .. '" -o "' .. exe_path .. '"')
        os.execute('cmd /c "' .. exe_run_path .. '"')
        delete_file(exe_path)
    else
        os.execute('gcc "' .. c_file .. '" -o "' .. exe_base .. '"')
        os.execute('./' .. exe_base)
        delete_file(exe_base)
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
    if is_windows() then
        local handle = io.popen('cmd /c "dir /b examples\\*.hc"')
        if handle then
            for file in handle:lines() do
                local full_path = "examples/" .. file
                run_single(full_path, keepc)
            end
            handle:close()
        end
    else
        local handle = io.popen('ls examples/*.hc')
        if handle then
            for file in handle:lines() do
                run_single(file, keepc)
            end
            handle:close()
        end
    end
end

-- CLI parsing
local arg1 = arg[1]
local arg2 = arg[2]

if arg1 == "--all" and arg2 == "--keepc" then
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