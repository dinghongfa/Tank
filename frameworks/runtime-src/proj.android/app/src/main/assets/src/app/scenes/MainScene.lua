local MainScene = class("MainScene",
                        function() return display.newScene("MainScene") end)
local Tank = require "app.Tank"

function MainScene:ctor()
    -- display.newTTFLabel({text = "少青，你好", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

    -- if not app._isLoaded then
    --     dragonBones.CCFactory:loadDragonBonesData("res/qznn_hall_npc_ske.json")
    --     dragonBones.CCFactory:loadTextureAtlasData("res/qznn_hall_npc_tex.json")
    --     app._isLoaded = true
    -- end
    -- local db = dragonBones.CCFactory:buildArmatureDisplay("qznn_hall_npc")
    -- self.db = db
    -- local ani = db:getAnimation()
    -- ani:play("newAnimation") -- 用于第一次播放
    -- db:addTo(self):pos(300, 700)


    print('Tank',Tank)

    -- if not app._isLoaded then
    --     dragonBones.CCFactory:loadDragonBonesData("res/loading_girl_ske.json")
    --     dragonBones.CCFactory:loadTextureAtlasData("res/loading_girl_tex.json")
    --     app._isLoaded = true
    -- end
    -- local db = dragonBones.CCFactory:buildArmatureDisplay("loading_girl")
    -- self.db = db
    -- local ani = db:getAnimation()
    -- ani:play("newAnimation") -- 用于第一次播放
    -- db:addTo(self):center()
    
end

function MainScene:onEnter()

    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames("res/tex.plist")

    local size = cc.Director:getInstance():getWinSize()

    self.tank = Tank.new(self, 'tank_green')
    self.tank.sp:setPosition(size.width / 2, size.height / 2)

    self:ProcessInput()

end

function MainScene:ProcessInput()

    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(function(keyCode, event)
        if self.tank ~= nil then
            if keyCode == 146 then
                self.tank:SetDir('up')
            elseif keyCode == 142 then
                self.tank:SetDir('down')
            elseif keyCode == 124 then
                self.tank:SetDir('left')
            elseif keyCode == 127 then
                self.tank:SetDir('right')
            end
        end

    end, cc.Handler.EVENT_KEYBOARD_PRESSED)

    local eventDispatcher = self:getEventDispatcher()

    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end

function MainScene:onExit() end

return MainScene
