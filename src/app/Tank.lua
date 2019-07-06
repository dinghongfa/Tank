local Object = require 'app.Object'
local SpriteAnim = require 'app.SpriteAnim'

local Tank = class('Tank', Object)
local Bullet = require 'app.Bullet'

function Tank:ctor(node, name, map, camp)
    Tank.super.ctor(self, node, camp)
    self.node = node
    self.map = map

    self.dx = 0
    self.dy = 0
    self.speed = 100
    self.OnCollide = nil
    self.bulletTable = {}

    self.dir = 'up'
    print('self.sp==', self.sp)
    self.spAnim = SpriteAnim.new(self.sp)
    self.spAnim:Define('run', name, 8, 0.1)
    self.spAnim:SetFrame('run', 0)
end

function Tank:Update()
    self:UpdataPosition(
        function(nextPosX, nextPosY)
            local hit
            hit = self.map:Collide(nextPosX, nextPosY, -5)

            if hit == nil then
                -- 活体碰撞
                hit = self:CheckCollide(nextPosX, nextPosY)
            end
            if hit and self.OnCollide then
                self.OnCollide(hit)
            end

            return hit
        end
    )
end

function Tank:SetDir(dir)
    if self.sp then
        if dir == nil then
            self.dx = 0
            self.dy = 0
            self.spAnim:Stop('run')
            return
        elseif dir == 'left' then
            self.dx = -self.speed
            self.dy = 0
            self.sp:setRotation(-90)
            self.spAnim:Play('run')
        elseif dir == 'right' then
            self.dx = self.speed
            self.dy = 0
            self.sp:setRotation(90)
            self.spAnim:Play('run')
        elseif dir == 'up' then
            self.dx = 0
            self.dy = self.speed
            self.sp:setRotation(0)
            self.spAnim:Play('run')
        elseif dir == 'down' then
            self.dx = 0
            self.dy = -self.speed
            self.sp:setRotation(180)
            self.spAnim:Play('run')
        end

        self.dir = dir
    end
end

function Tank:Destory()
    print('坦克Tank:Destory...')
    print('self.bulletTable,', #self.bulletTable)
    for k, v in pairs(self.bulletTable) do
        print('销毁子弹', k, v)
        v:Destory()
        v = nil
    end
    self.spAnim:Destory()
    Tank.super.Destory(self)
end

function Tank:Fire()
    -- statements
    print('self.bullet===', self.bullet)
    if self.bullet then
        --todo
        print('self.bullet:Alive()===', self.bullet:Alive())
    end
    if self.bullet ~= nil and self.bullet:Alive() then
        return
    end

    self.bullet = Bullet.new(self.node, self.map, 0, self, self.dir)
    table.insert(self.bulletTable, self.bullet)
end

return Tank
