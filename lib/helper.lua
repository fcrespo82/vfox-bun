local helper = {}

function helper:dump(tbl)
    io.write("{")
    for k, v in pairs(tbl) do
        io.write(k .. " = ")
        if type(v) == "table" then
            helper:dump(v)
        else
            io.write(tostring(v))
        end
        io.write(", ")
    end
    io.write("}")
end

function helper:printTable(t, f)

    local function printTableHelper(obj, cnt)

        local cnt = cnt or 0

        if type(obj) == "table" then

            io.write("\n", string.rep("\t", cnt), "{\n")
            cnt = cnt + 1

            for k, v in pairs(obj) do

                if type(k) == "string" then
                    io.write(string.rep("\t", cnt), '["' .. k .. '"]', ' = ')
                end

                if type(k) == "number" then
                    io.write(string.rep("\t", cnt), "[" .. k .. "]", " = ")
                end

                printTableHelper(v, cnt)
                io.write(",\n")
            end

            cnt = cnt - 1
            io.write(string.rep("\t", cnt), "}")

        elseif type(obj) == "string" then
            io.write(string.format("%q", obj))

        else
            io.write(tostring(obj))
        end
    end

    if f == nil then
        printTableHelper(t)
    else
        io.output(f)
        io.write("return")
        printTableHelper(t)
        io.output(io.stdout)
    end
end

return helper
