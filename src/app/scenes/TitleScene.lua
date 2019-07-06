require('app.Common')

local PlayerTank = require('app.PlayerTank')
local Map = require('app.Map')

local TitleScene =
    class(
    'TitleScene',
    function()
        return display.newScene('TitleScene')
    end
)

function TitleScene:onEnter()
    -- statements
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames('res/tex.plist')

    self.map = Map.new(self)
    self.map:Load('title.lua')
    self.tank = PlayerTank.new(self, 'tank_green', self.map)
    self.tank:SetPos(5, 1)
    self:ProcessInput()
end

local editorFileName = 'editor.lua'

function TitleScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(
        function(keyCode, event)
            print('keyCode', keyCode)
            if self.tank ~= nil then
                if keyCode == 124 then
                    -- a
                    self.tank:SetPos(5, 1)
                elseif keyCode == 127 then
                    -- d
                    self.tank:SetPos(11, 1)
                elseif keyCode == 133 then
                    -- j
                    local sceneName
                    local x, _ = self.tank:GetPos()
                    if x == 5 then
                        sceneName = 'app.scenes.MainScene'
                    else    
                        sceneName = 'app.scenes.EditorScene'
                    end
                    local s = require(sceneName).new()
                    display.replaceScene(s, 'fade', 0.6, display.COLOR_BLACK)
                end
            end
        end,
        cc.Handler.EVENT_KEYBOARD_RELEASED
    )

    local eventDispatcher = self:getEventDispatcher()

    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function TitleScene:onExit()
    print('开始选择页面销毁')
    self.tank:Destory()
end

return TitleScene
