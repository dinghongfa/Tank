require('app.Common')
require('app.Camp')

local TankCursor = require('app.TankCursor')
local Map = require('app.Map')

local EditorScene =
    class(
    'EditorScene',
    function()
        return display.newScene('EditorScene')
    end
)

function EditorScene:onEnter()
    -- statements
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames('res/tex.plist')

    self.map = Map.new(self)
    self.tank = TankCursor.new(self, 'tank_green', self.map)
    self.tank:PlaceCursor(MapWidth / 2, MapHeight / 2)
    self:ProcessInput()
end

local editorFileName = 'editor.lua'

function EditorScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(
        function(keyCode, event)
            print('keyCode', keyCode)
            if self.tank ~= nil then
                if keyCode == 146 then
                    self.tank:MoveCursor(0, 1)
                elseif keyCode == 142 then
                    self.tank:MoveCursor(0, -1)
                elseif keyCode == 124 then
                    self.tank:MoveCursor(-1, 0)
                elseif keyCode == 127 then
                    self.tank:MoveCursor(1, 0)
                elseif keyCode == 133 then
                    -- j
                    self.tank:SwitchBlock(1)
                elseif keyCode == 134 then
                    -- k
                    self.tank:SwitchBlock(-1)
                elseif keyCode == 49 then
                    -- F3
                    self.map:Load(editorFileName)
                elseif keyCode == 50 then
                    -- F4
                    self.map:Save(editorFileName)

                elseif keyCode==6 then 
                    local s = require('app.scenes.TitleScene').new()
                    display.replaceScene(s, 'fade', 0.6, display.COLOR_BLACK)
                end
            end
        end,
        cc.Handler.EVENT_KEYBOARD_RELEASED
    )

    local eventDispatcher = self:getEventDispatcher()

    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return EditorScene
