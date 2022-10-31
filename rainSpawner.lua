local pd <const> = playdate
local gfx <const> = pd.graphics

import "rainParticle"

class('RainSpawner').extends(gfx.sprite)

function RainSpawner:init()

    self:setZIndex(100)
    
    self.delay = gfx.animator.new(30, 1, 250, pd.easingFunctions.linear)
    self.randomnum = math.random(0, 400)

    self:add()
end

function RainSpawner:update()

    self:Rain()

end

function RainSpawner:Rain()

    if self.delay:ended() then
        self.randomnum = math.random(0, 400) --in build, this is offset by player position
        RainParticle(self.randomnum)
    end
end