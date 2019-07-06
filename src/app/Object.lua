local Object = class('Object')
require('app.Common')
require('app.Camp')
function Object:ctor(node, camp)
    Camp_Add(camp, self)

    self.sp = cc.Sprite:create()
    self.node = node
    self.node:addChild(self.sp)

    print('公共Object:ctor  ---  self.Update ，=', self.Update)
    if self.Update ~= nil then
        print('  self.updataFuncID...', self.updataFuncID)
        self.updataFuncID =
            cc.Director:getInstance():getScheduler():scheduleScriptFunc(
            function()
                self:Update()
            end,
            0,
            false
        )
    end
end

function Object:Alive()
    return self.sp ~= nil
end

function Object:GetPos()
    return Pos2Grid(self.sp:getPositionX(), self.sp:getPositionY())
end

function Object:SetPos(x, y)
    local posx, posy = Grid2Pos(x, y)
    self.sp:setPosition(posx, posy)
end

function Object:GetRect()
    return NewRect(self.sp:getPositionX(), self.sp:getPositionY())
end

function Object:UpdataPosition(callback)
    local delta = cc.Director:getInstance():getDeltaTime()

    -- 下一个位置
    -- print('self.sp====',self.sp)

    xpcall(
        function()
            local nextPosX = self.sp:getPositionX() + self.dx * delta
            local nextPosY = self.sp:getPositionY() + self.dy * delta

            if callback(nextPosX, nextPosY) then
                -- 拦截移动，在碰到墙壁的时候阻止移动
                return
            end
            if self.dx ~= 0 then
                self.sp:setPositionX(nextPosX)
            end
            if self.dy ~= 0 then
                self.sp:setPositionY(nextPosY)
            end
        end,
        function()
            -- print('错误')
        end
    )

    -- local nextPosX = self.sp:getPositionX() + self.dx * delta
    -- local nextPosY = self.sp:getPositionY() + self.dy * delta

    -- if callback(nextPosX, nextPosY) then
    --     -- 拦截移动，在碰到墙壁的时候阻止移动
    --     return
    -- end
    -- if self.dx ~= 0 then
    --     self.sp:setPositionX(nextPosX)
    -- end
    -- if self.dy ~= 0 then
    --     self.sp:setPositionY(nextPosY)
    -- end
end

function Object:Stop()
    self.dx = 0
    self.dy = 0
end

function Object:CheckCollide(posx, posy, ex)
    -- 活体之间的碰撞
    local selfrect = NewRect(posx, posy, ex)

    return Camp_IterateAll(
        function(obj)
            if obj == self then
                return false
            end

            local tgtrect = obj:GetRect()

            if RectIntersect(selfrect, tgtrect) ~= nil then
                return obj
            end
        end
    )
end

function Object:CheckHit(posx, posy)
    -- 点碰撞活体
    return Camp_IterateHostile(
        self.camp,
        function(obj)
            local tgtrect = obj:GetRect()
            if RectHit(tgtrect, posx, posy) then
                return obj
            end
        end
    )
end

function Object:Destory()
    print('销毁----updateFuncID==', self.updataFuncID)
    print('销毁----self.sp==', self.sp)
    Camp_Remove(self)
    if self.updataFuncID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updataFuncID)
    end
    if self.node and self.sp then
        self.node:removeChild(self.sp)
    end
    self.sp = nil
end

return Object
