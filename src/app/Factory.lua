require('app.Common')
local AITank = require('app.AITank')
local Factory = class('Factory')

function Factory:ctor(node, map)
    self.map = map
    self.node = node
    self.enemyTable = {}
    self.updataFuncID =
        cc.Director:getInstance():getScheduler():scheduleScriptFunc(
        function()
            self:SpawnRandom()
        end,
        5,
        false
    )

    self:SpawnRandom()
end

function Factory:SpawnRandom()
    local x, y = self:GeneratePos()
    self:SpawnByPos(x, y)
end

function Factory:GeneratePos()
    while true do
        local x = math.random(0, MapWidth - 1)
        local y = math.random(0, MapHeight - 1)

        if self:CheckPos(x, y) then
            return x, y
        end
    end
end

function Factory:CheckPos(x, y)
    local block = self.map:Get(x, y)
    local blockRect = block:GetRect()

    if block.type == 'mud' then
        if
            not Camp_IterateAll(
                function(obj)
                    local tgtrect = obj:GetRect()
                    if RectIntersect(blockRect, tgtrect) ~= nil then
                        return true
                    end
                end
            )
         then
            return true
        end
    end
end

function Factory:SpawnByPos(x, y)
    local ememyTank = AITank.new(self.node, 'tank_blue', self.map, 'enemy')
    ememyTank:SetPos(x, y)
    table.insert(self.enemyTable, ememyTank)
end

function Factory:Destory()
    print('退出时销毁所有敌方对象self.enemyTable', #self.enemyTable)
    if self.updataFuncID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updataFuncID)
    end
    for k, v in pairs(self.enemyTable) do
        print(k, v)
        v:Destory()
        v = nil
    end
end

return Factory
