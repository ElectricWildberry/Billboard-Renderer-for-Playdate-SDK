local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('Camera').extends(gfx.sprite)

function Camera:init(x, y, z) --do be careful that y is inverted.
			      -- also, x position need to be inverted when using playdate coordinates (i.e. collision library and sprite.moveTo, movewithCollisions)

    self:moveTo(x, z)

    --aiming
    self.currentDir = geo.vector2D.new(0, 0) -- this stores the direction (forward) of the camera as a 2d vector
    self.dirRight = geo.vector2D.new(0, 0) -- this stores the right direction (forward + 90) of the camera as a 2d vector
    self.input = geo.vector2D.new(0, 0) -- this stores the input of the user (2d vector is used so functions like "normalize" can be utilized)
    --aiming

    --rendering
    self.xpos = x
    self.ypos = y -- these variables must be changed at runtime in order to move the camera. using self:moveTo will not.
    self.zpos = z

    self.far = 400 --far plane
    self.near = 10 --newar plane
    self.angle = 0 --crank angle
    --rendering

    --movement
    self.speed = 70 --how fast the camera moves (you can tie the camera to a player sprite and not use this variable instead)
    --movement

    self:add()
    
end

function Camera:update()

    self:Move() --putting move logic in a function to declutter (in case you want to expand this)
    
end

function Camera:Move()

    self.angle = pd.getCrankPosition()
    local degrees = self.angle
    local rad = math.rad(degrees + 90)
    
    self.currentDir.dx = math.cos(rad)
    self.currentDir.dy = math.sin(rad)
    self.dirRight.dx = math.sin(math.rad(degrees - 90))
    self.dirRight.dy = math.cos(math.rad(degrees - 90))

    self.input.dx = 0
    self.input.dy = 0

    if pd.buttonIsPressed(pd.kButtonUp) then
        self.input.dy = -1
    end

    if pd.buttonIsPressed(pd.kButtonDown) then
        self.input.dy = 1
    end 

    if pd.buttonIsPressed(pd.kButtonRight) then
        self.input.dx = 1
    end

    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.input.dx = -1
    end

    self.currentDir:normalize()
    self.dirRight:normalize()
    self.input:normalize()

    self.zpos = self.zpos + (self.currentDir.dy * self.input.dy) * self.speed / pd.display.getRefreshRate() 
    self.xpos = self.xpos + (self.currentDir.dx * -self.input.dy) * self.speed / pd.display.getRefreshRate()  -- calling pd.display.getRefreshRate() once somewhere else, then calling the variable is much better, as this actually takes a bit of time
    self.zpos = self.zpos + (self.dirRight.dy * self.input.dx) * self.speed / pd.display.getRefreshRate() 
    self.xpos = self.xpos + (self.dirRight.dx * self.input.dx) * self.speed / pd.display.getRefreshRate() 

end
