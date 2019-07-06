local Object = require('app.Object')
local Block = class('Block', Object)

local MaxBreakableStep = 3

local blockPropertyTable = {
    -- 泥土
    ['mud'] = {
        ['hp'] = 0,
        ['needAp'] = false, --是否需要穿甲弹
        --阻尼
        ['damping'] = 0.2,
        --是否可以破坏
        ['breakable'] = false
    },
    -- 路面
    ['road'] = {
        ['hp'] = 0,
        ['needAp'] = false, --是否需要穿甲弹
        --阻尼
        ['damping'] = 0,
        --是否可以破坏
        ['breakable'] = false
    },
    -- 草地
    ['grass'] = {
        ['hp'] = 0,
        ['needAp'] = false, --是否需要穿甲弹
        --阻尼
        ['damping'] = 0,
        --是否可以破坏
        ['breakable'] = false
    },
    -- 水区域
    ['water'] = {
        ['hp'] = 0,
        ['needAp'] = false, --是否需要穿甲弹
        --阻尼
        ['damping'] = 1,
        --是否可以破坏
        ['breakable'] = false
    },
    -- 砖块
    ['brick'] = {
        ['hp'] = MaxBreakableStep,
        ['needAp'] = false, --是否需要穿甲弹
        --阻尼
        ['damping'] = 1,
        --是否可以破坏
        ['breakable'] = true
    },
    -- 钢铁
    ['steel'] = {
        ['hp'] = MaxBreakableStep,
        ['needAp'] = true, --是否需要穿甲弹
        --阻尼
        ['damping'] = 1,
        --是否可以破坏
        ['breakable'] = true
    }
}

function Block:ctor(node)
    -- statements
    Block.super.ctor(self, node)
end

function Block:Break()
    if not self.breakable then
        return
    end

    self.hp = self.hp - 1
    if self.hp < 0 then
        self:Reset('mud')
    else
        self:updateImage()
    end
end

function Block:updateImage()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()

    local spriteName
    if self.breakable then
        spriteName = string.format('%s%d.png', self.type, MaxBreakableStep - self.hp)
    else
        spriteName = string.format('%s.png', self.type)
    end

    local frame = spriteFrameCache:getSpriteFrame(spriteName)
    if frame == nil then
        print('sprite frame not found', self.type)
    else
        self.sp:setSpriteFrame(frame)
        if self.type == 'grass' then
            self.sp:setLocalZOrder(10)
            self.sp:setOpacity(200)
        else
            self.sp:setLocalZOrder(0)
            self.sp:setOpacity(255)
        end
    end
end

function Block:Reset(type)
    -- statements
    local t = blockPropertyTable[type]
    print('t===', t)
    -- assert(t)
    if not t then
        return
    end

    for k, v in pairs(t) do
        print(k, v)
        self[k] = v
    end
    self.type = type
    self:updateImage()
end

return Block
