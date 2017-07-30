
local breakInfoFun, xpCallFun = require("luadebugNjit")("localhost", 7003)
-- cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)
CCDirector:sharedDirector()::getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)

cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    xpCallFun()
end

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
