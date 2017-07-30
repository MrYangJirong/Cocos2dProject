
local size = cc.Director:getInstance():getWinSize()

local kBoxA_Tag = 102
local kBoxB_Tag = 103
local kBoxC_Tag = 104

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    self:createLayer()
end

function MainScene:ctor()
    cc.load("mvc").ViewBase.ctor(self, app, name)
end

local function touchBegan(touch, event)
    --获取事件所绑定的node
    local node = event:getCurrentTarget()
    --获取当前点击点所在相对按钮的位置坐标
    local locationInNode = node:convertToNodeSpace(touch:getLocation())
    local s = node:getContentSize()
    local rect = cc.rect(0, 0, s.width, s.height)

    --点击范围判断
    if cc.rectContainsPoint(rect, locationInNode) then
        printInfo("Sprite x = %f, y = %f", locationInNode.x, locationInNode.y)
        printInfo("sprite tag = %d", node:getTag())
        node:runAction(cc.ScaleBy:create(0.06, 1.06))
        return true
    end
    return false
end

local function touchMoved(touch, event)
    local node = event:getCurrentTarget()

    local currentPosX, currentPosY = node:getPosition()
    local diff = touch:getDelta() --位移增量
    node:setPosition(cc.p(currentPosX+diff.x, currentPosY+diff.y))
end

local function touchEnded(touch, event)
    printInfo("touchEnded")
    local node = event:getCurrentTarget()
    local locationInNode = node:convertToNodeSpace(touch:getLocation())
    local s = node:getContentSize()
    local rect = cc.rect(0, 0, s.width, s.height)

    if cc.rect(rect, locationInNode) then
        node:runAction(cc.ScaleTo:create(0.06, 1.0))
    end
end

--创建层
function MainScene:createLayer()
    print("createLayer")
    local layer = cc.Layer:create()
    layer:addTo(self)

    --背景图
    local bg = cc.Sprite:create("ch10/BackgroundTile.png", cc.rect(0, 0, size.width, size.height))
    bg:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
    bg:setPosition(cc.p(size.width/2, size.height/2))
    layer:addChild(bg, 0)
    local boxA = cc.Sprite:create("ch10/BoxA2.png")
    boxA:setPosition(cc.p(size.width/2 - 120, size.height/2 + 120))
    layer:addChild(boxA, 10, kBoxA_Tag)
    local boxB = cc.Sprite:create("ch10/BoxB2.png")
    boxB:setPosition(cc.p(size.width/2, size.height/2))
    layer:addChild(boxB, 20, kBoxB_Tag)
    local boxC = cc.Sprite:create("ch10/BoxC2.png")
    boxC:setPosition(cc.p(size.width/2 + 120, size.height/2 + 160))
    layer:addChild(boxC, 30, kBoxC_Tag)

    ---[[
    --创建一个事件监听器
    local listener1 = cc.EventListenerTouchOneByOne:create()
    --设置是否吞没事件，在onTouchBegan返回true时吞没
    listener1:setSwallowTouches(true)
    --事件回调函数
    listener1:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener1:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener1:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    --注册事件分发器
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    --给事件分发器添加监听器
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, boxA)
    local listener2 = listener1:clone()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener2, boxB)
    local listener3 = listener1:clone()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener3, boxC)
    --]]

    return layer
end

return MainScene
