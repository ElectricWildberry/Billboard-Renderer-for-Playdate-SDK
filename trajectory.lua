import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Trajectory').extends(gfx.sprite)

function Trajectory:init()
    Trajectory.super.init(self)
    self:add()
end

function Trajectory:Rotate(x, y, rotation)

    self:moveTo(x+4, y+4)

    local maxLength = 150
	local height = 3
	local trajectoryImage = gfx.image.new(maxLength, height)

	gfx.pushContext(trajectoryImage)
		gfx.fillRect(75, 0, maxLength, height)
	gfx.popContext()

    self:setImage(trajectoryImage:rotatedImage(rotation))

end