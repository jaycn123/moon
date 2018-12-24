local moon = require("moon")
local test_assert = require("test_assert")

local send_content = "123456789"

local command = {}

command.WORLD = function(s)
    test_assert.equal(s, send_content)
    test_assert.success()
end

local function docmd(header, ...)
    local f = command[header]
    if f then
        f(...)
    else
        error(string.format("Unknown command %s", tostring(header)))
    end
end

moon.dispatch(
    "lua",
    function(msg, p)
        local header = msg:header()
        docmd(header, p.unpack(msg))
    end
)

local receiver

moon.init(function()
    receiver = moon.new_service(
        "lua",
        {
            name = "test_send_receiver",
            file = "test_send_receiver.lua"
        }
    )

    return true
end)

moon.start(
    function()
        moon.send("lua", receiver, "HELLO", "123456789")
    end
)

moon.destroy(function()
    moon.remove_service(receiver)
end)