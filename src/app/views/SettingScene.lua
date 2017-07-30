
local size = cc.Director:getInstance():getWinSize()

local MUSIC_FILE = "ch11/sound/Synth.mp3"

local SettingScene = class("SettingScene", function()
    return cc.Scene:create()
end)

function SettingScene:create()
    local scene = SettingScene.new()
    scene:addChild(scene:createLayer())
    return scene
end

function SettingScene:ctor()
    printInfo("SettingScene ctor函数！！")
    --场景节点事件处理
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "enterTransitionFinish" then
            self:onEnterTransitionFinish()
        elseif event == "exit" then
            self:onExit()
        elseif event == "exitTransitionStart" then
            self:onExitTransitionStart()
        elseif event == "cleanup" then
            self:cleanup()
        end
    end

    self:registerScriptHandler(onNodeEvent)
end

-- create layer
function SettingScene:createLayer()
    local layer = cc.Layer:create()

    local bg = cc.Sprite:create("ch11/setting-back.png")
    bg:setPosition(cc.p(size.width / 2,
    size.height / 2))
    layer:addChild(bg)

    -- 音效
    local soundOnMenuItem = cc.MenuItemImage:create("ch11/on.png", "on.png")
    local soundOffMenuItem = cc.MenuItemImage:create("ch11/off.png", "off.png")
    local soundToggleMenuItem = cc.MenuItemToggle:create(soundOffMenuItem, soundOnMenuItem)
    soundToggleMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(818, 220)))
    local function menuSoundToggleCallback(sender)
        printInfo("Sound Toggle.")
        if isEffect then
            AudioEngine.playEffect(EFFECT_FILE)
        end
        if soundToggleMenuItem:getSelectedIndex() == 1 then
            -- 选中状态off -> on 
            isEffect = false
        else
            isEffect = true
        end

    end
    soundToggleMenuItem:registerScriptTapHandler(menuSoundToggleCallback)

    -- 音乐
    local musicOnMenuItem = cc.MenuItemImage:create("ch11/on.png", "on.png")
    local musicOffMenuItem = cc.MenuItemImage:create("ch11/off.png", "off.png")
    local musicToggleMenuItem = cc.MenuItemToggle:create(musicOffMenuItem, musicOnMenuItem)
    musicToggleMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(818, 362)))
    local function menuMusicToggleCallback(sender)
        printInfo("Music Toggle.")
        if isEffect then
            AudioEngine.playEffect(EFFECT_FILE)
        end
        if musicToggleMenuItem:getSelectedIndex() == 1 then
            -- 选中状态Off -> On
            AudioEngine.stopMusic()
        else
            AudioEngine.playMusic(MUSIC_FILE, true)
        end
    end
    musicToggleMenuItem:registerScriptTapHandler(menuMusicToggleCallback)

    -- OK按钮
    local okMenuItem = cc.MenuItemImage:create(
    "ch11/ok-down.png",
    "ch11/ok-up.png")
    okMenuItem:setPosition(cc.Director:getInstance():convertToGL(cc.p(600, 510)))
    local function menuOkCallback(sender)
        printInfo("Ok Menu tap.")
        cc.Director:getInstance():popScene()
        if isEffect then
            AudioEngine.playEffect(EFFECT_FILE)
        end
    end
    okMenuItem:registerScriptTapHandler(menuOkCallback)

    local mn = cc.Menu:create(soundToggleMenuItem, musicToggleMenuItem, okMenuItem)
    mn:setPosition(cc.p(0, 0))
    layer:addChild(mn)
    return layer
end

function SettingScene:onEnter()
    printInfo("SettingScene onEnter")
end

function SettingScene:onEnterTransitionFinish()
    printInfo("SettingScene onEnterTransitionFinish")
    AudioEngine.playMusic(MUSIC_FILE, true)
end

function SettingScene:onExit()
    printInfo("SettingScene onExit")
end

function SettingScene:onExitTransitionStart()
    printInfo("SettingScene onExitTransitionStart")
end

function SettingScene:cleanup()
    printInfo("SettingScene cleanup")
    -- AudioEngine.stopMusic()
end

return SettingScene