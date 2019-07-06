require('app.Common')
local Tank = require 'app.Tank'
local PlayerTank = require 'app.PlayerTank'
local Map = require('app.Map')
require 'app.camp'
local Factory = require('app.Factory')

local MainScene =
    class(
    'MainScene',
    function()
        return display.newScene('MainScene')
    end
)

function MainScene:ctor()
    print('Tank', Tank)
end

function MainScene:onEnter()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames('res/tex.plist')

    Camp_SetHostile('player', 'enemy', true)
    Camp_SetHostile('enemy', 'player', true)

    Camp_SetHostile('player.bullet', 'enemy', true)
    Camp_SetHostile('enemy.bullet', 'player', true)

    Camp_SetHostile('enemy.bullet', 'player.bullet', true)
    Camp_SetHostile('player.bullet', 'enemy.bullet', true)

    self.map = Map.new(self)
    self.map:Load('level.lua')

    self.factory = Factory.new(self, self.map)

    local size = cc.Director:getInstance():getWinSize()

    -- self.tank = Tank.new(self, 'tank_green')
    self.tank = PlayerTank.new(self, 'tank_green', self.map, 'player')
    self.tank:SetPos(6, 1)

    -- Tank.new(self, 'tank_blue', self.map, 'enemy'):SetPos(3, 4)

    self:ProcessInput()
end

function MainScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(
        function(keyCode, event)
            print('按下')
            if self.tank ~= nil then
                if keyCode == 146 then
                    self.tank:MoveBegin('up')
                elseif keyCode == 142 then
                    self.tank:MoveBegin('down')
                elseif keyCode == 124 then
                    self.tank:MoveBegin('left')
                elseif keyCode == 127 then
                    self.tank:MoveBegin('right')
                end
            end
        end,
        cc.Handler.EVENT_KEYBOARD_PRESSED
    )

    listener:registerScriptHandler(
        function(keyCode, event)
            print('抬起')
            if self.tank ~= nil then
                if keyCode == 146 then
                    self.tank:MoveEnd('up')
                elseif keyCode == 142 then
                    self.tank:MoveEnd('down')
                elseif keyCode == 124 then
                    self.tank:MoveEnd('left')
                elseif keyCode == 127 then
                    self.tank:MoveEnd('right')
                elseif keyCode == 133 then
                    -- j
                    self.tank:Fire()
                elseif keyCode == 134 then
                    -- k
                    self.factory:SpawnRandom()
                elseif keyCode == 6 then
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

function MainScene:onExit()
    self.tank:Destory()
    self.factory:Destory()
end

return MainScene
