--[[原始hello world代码
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local size = cc.Director:getInstance():getWinSize()
function MainScene:onCreate()
    -- add background image
        bg = cc.Sprite:create("HelloWorld.png")
        bg:setPosition(cc.p(size.width/2, size.height/2))
        bg:addTo(self)

    -- add HelloWorld label
        myLabel = cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        myLabel:setPosition(cc.p(size.width/2, size.height/2 + 200))
        myLabel:addTo(self)
    print("断点调试")
end

return MainScene]]


--===========================================================================

local size = cc.Director:getInstance():getWinSize()

EFFECT_FILE = "ch11/sound/Blip.wav"
MUSIC_FILE = "ch11/sound/Jazz.mp3"
isEffect = true

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    self:createLayer()
end

-- 添加注释
function MainScene:ctor(app, name)
    print("调用ctor方法！！")
    
    self:onNodeEvent("enter", function()
        self:onEnter()
        print("enter事件")
    end)

     self:onNodeEvent("enterTransitionFinish", function()
        self:onEnterTransitionFinish()
    end)

     self:onNodeEvent("exit", function()
        self:onExit()
    end)

     self:onNodeEvent("exitTransitionStart", function()
        self:onExitTransitionStart()
    end)

     self:onNodeEvent("cleanup", function()
        self:cleanup()
    end)

    cc.load("mvc").ViewBase.ctor(self, app, name)
end

function MainScene:createLayer() 
    printInfo("调用createLayer方法！!")

    local layer = cc.Layer:create()
    layer:addTo(self)

    local bg = cc.Sprite:create("ch11/background.png")
    bg:setPosition(cc.p(size.width/2, size.height/2))
    bg:addTo(layer)

    local startlocalNormal = cc.Sprite:create("ch11/start-up.png")
    local startlocalSelected = cc.Sprite:create("ch11/start-down.png")
    local startMenuItem = cc.MenuItemSprite:create(startlocalNormal, startlocalSelected)
    startMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(700, 170)))
    local function menuItemStartCallback(sender)
        printInfo("Touch Start.")
        if isEffect then
            AudioEngine.playEffect(EFFECT_FILE)
        end
    end
    startMenuItem:registerScriptTapHandler(menuItemStartCallback)
    
    -- 设置图片菜单
    local settingMenuItem = cc.MenuItemImage:create(
        "ch11/setting-up.png",
        "ch11/setting-down.png")
    settingMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(480, 400)))
    local function menuItemSettingCallback(sender)
        printInfo("Touch Setting.")
        local scene = require("src/app/views/SettingScene")
        local settingScene = scene.create()
        local ts = cc.TransitionJumpZoom:create(1, settingScene)
        cc.Director:getInstance():pushScene(ts)
        

        if isEffect then
            AudioEngine.playEffect(EFFECT_FILE)
        end

    end
    settingMenuItem:registerScriptTapHandler(menuItemSettingCallback)

    -- 帮助图片菜单
    local helpMenuItem = cc.MenuItemImage:create(
        "ch11/help-up.png",
        "ch11/help-down.png")

    helpMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(860, 480)))
    local function menuItemHelpCallback(sender)
        printInfo("Touch Help.")

        if isEffect then
            AudioEngine.playEffect(EFFECT_FILE)
        end
    end
    helpMenuItem:registerScriptTapHandler(menuItemHelpCallback)

    local mn = cc.Menu:create(startMenuItem, settingMenuItem, helpMenuItem)
    mn:setPosition(cc.p(0, 0))
    layer:addChild(mn)

    return layer
end

function MainScene:onEnter()
    printInfo("MainScene onEnter")
end

function MainScene:onEnterTransitionFinish()
    printInfo("MainScene onEnterTransitionFinish")
    AudioEngine.playMusic(MUSIC_FILE, true)
end

function MainScene:onExit()
    printInfo("MainScene onExit")
end

function MainScene:onExitTransitionStart()
    printInfo("MainScene onExitTransitionStart")
    AudioEngine.stopMusic()
end

function MainScene:cleanup()
    printInfo("MainScene cleanup")
    --AudioEngine.stopMusic()
end

return MainScene
