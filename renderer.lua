local pd <const> = playdate
local gfx <const> = pd.graphics

local fieldscale = 4 --how big the ground sprite is rendered (mode7)
local angle = 130 * (math.pi/180) --local variable to calculate angle

class('Renderer').extends(gfx.sprite)

function Renderer:init(camera, ground, sky)

    self:setSize(200, 120)
    self:moveTo(100,60)
    self:setIgnoresDrawOffset(true)
    self:setZIndex(100)

    self.camera = camera
    self.pic = gfx.image.new(200, 120) -- this is where everything is drawn

    self.tri_queue = {} -- this is where all billboards are located
    self.plane_queue = {} -- unused
    self.sphere_queue = {} -- usable, just renders spheres (circles)

    self.ground = ground -- an image for the ground
    self.trackwidth, self.trackheight = self.ground:getSize()
    self.sky = sky -- an image for the sky
    self.ox = self.trackwidth / 2
    self.oy = self.trackheight / 2

    self.draw_Queue = {} -- all billboards are reordered and placed here to render
    self.sortTimer = 0 --how often z sorting occurs

    self:add()
    
end

function Renderer:update()

    local degrees = self.camera.angle

    if (degrees % 45) == 0 then
        degrees += 1 -- playdate has trouble calculating increments of 45 degrees (probably a divide by zero thing) so this prevents that from happening
    end
    
    local rad = math.rad(degrees) --convert to radians so the billboards can calculate in sin cos

    if self.sortTimer == 0 then
        table.sort(self.tri_queue,function(a, b)
            return tonumber(a.rotz) < tonumber(b.rotz) -- this is a quicksort solely for billboards
        end)
        self.sortTimer = 60 -- reset the timer (here it is every 2 seconds, due to the framerate limit being 30) 
    else
        self.sortTimer -= 1
    end

    gfx.pushContext(self.pic)
    
        gfx.setColor(gfx.kColorClear)
        gfx.fillRect(0,0,200,120)

        self:RenderFloor()
        self:RenderSky()

        for index, value in ipairs(self.tri_queue) do
            if value:Order(rad) then -- this function prevents sprites from trying to calculate render positions when they aren't even in the view
                value:ShowSelf(rad)
                gfx.setColor(gfx.kColorBlack)
            end
        end

    gfx.popContext()

    self:setImage(self.pic)

end

function Renderer:RenderFloor() --uses mode7 (drawsampled) to draw on a tilted plane, creating a "fake" 3d landscape

    angle = self.camera.angle * (math.pi/180)
	
    if angle < 0 then angle += 2 * math.pi end
    if angle > 2 * math.pi then angle -= 2 * math.pi end

    local c = math.cos(angle)
    local s = math.sin(angle)

    self.ground:drawSampled(0, 70, 200, 50,  -- x, y, width, height
                0.5, 1.5, -- center x, y
                c / fieldscale, s / fieldscale, -- dxx, dyx
                -s / fieldscale, c / fieldscale, -- dxy, dyy
                (self.ox - self.camera.xpos/2.3)/self.trackwidth, (self.oy + self.camera.zpos/2.5)/self.trackheight, -- dx, dy -- the /2.3 is to accomodate for the fov problem
                600, -- z
                78, -- tilt angle
                false); -- tile

end

function Renderer:RenderSky() -- renders the sky in a continued and seamless way
    skyx = -300 * self.camera.angle * (math.pi/180) / math.pi * 1.5
    self.sky:draw(skyx, 0)
    
    if skyx < -200 then
        self.sky:draw(skyx + 600, 0)
    end
end
