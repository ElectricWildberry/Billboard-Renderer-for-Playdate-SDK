local pd <const> = playdate
local gfx <const> = pd.graphics

class('RainParticle').extends(gfx.sprite)

function RainParticle:init(xpos)

    self:moveTo(xpos, 80)
    self:setZIndex(100)

    self.lineTimer1 = gfx.animator.new(800, 1, 250, pd.easingFunctions.inQuart)

    self:add()

end

function RainParticle:update()

	local trajectoryImage1 = gfx.image.new(1, 280)
    local rotation = 4

	gfx.pushContext(trajectoryImage1)
        gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, self.lineTimer1:currentValue(), 1, 50)
	gfx.popContext()

    self:setImage(trajectoryImage1:rotatedImage(rotation))

    if self.lineTimer1:ended() then
        self.lineTimer1:reset()
        self:remove()
    end

end