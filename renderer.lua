local pd <const> = playdate
local gfx <const> = pd.graphics

local fieldscale = 4
local angle = 130 * (math.pi/180)

class('Renderer').extends(gfx.sprite)

function Renderer:init(camera, ground, sky)

    self:setSize(200, 120)
    self:moveTo(100,60)
    self:setIgnoresDrawOffset(true)
    self:setZIndex(100)

    self.camera = camera
    self.pic = gfx.image.new(200, 120)

    self.tri_queue = {}
    self.plane_queue = {}
    self.sphere_queue = {}

    self.ground = ground
    self.trackwidth, self.trackheight = self.ground:getSize()
    self.sky = sky
    self.ox = self.trackwidth / 2
    self.oy = self.trackheight / 2

    self.draw_Queue = {}
    self.sortTimer = 0

    self:add()
    
end

function Renderer:update()

    local degrees = self.camera.angle

    if (degrees % 45) == 0 then
        degrees += 1
    end
    
    local rad = math.rad(degrees)

    if self.sortTimer == 0 then
        table.sort(self.tri_queue,function(a, b)
            return tonumber(a.rotz) < tonumber(b.rotz)
        end)
        self.sortTimer = 60
    else
        self.sortTimer -= 1
    end

    gfx.pushContext(self.pic)
    
        gfx.setColor(gfx.kColorClear)
        gfx.fillRect(0,0,200,120)

        self:RenderFloor()
        self:RenderSky()

        for index, value in ipairs(self.tri_queue) do
            if value:Order(rad) then
                value:ShowSelf(rad)
                gfx.setColor(gfx.kColorBlack)
                --gfx.drawRect(value.drawx + 100 - value.drawSizeX/2, value.drawy + 60, value.w * value.s, value.h * value.s)
            end
        end

    gfx.popContext()

    self:setImage(self.pic)

end

function Renderer:RenderFloor()

    angle = self.camera.angle * (math.pi/180)
	
    if angle < 0 then angle += 2 * math.pi end
    if angle > 2 * math.pi then angle -= 2 * math.pi end

    local c = math.cos(angle)
    local s = math.sin(angle)

    self.ground:drawSampled(0, 70, 200, 50,  -- x, y, width, height
                0.5, 1.5, -- center x, y
                c / fieldscale, s / fieldscale, -- dxx, dyx
                -s / fieldscale, c / fieldscale, -- dxy, dyy
                (self.ox - self.camera.xpos/2.3)/self.trackwidth, (self.oy + self.camera.zpos/2.5)/self.trackheight, -- dx, dy
                600, -- z
                78, -- tilt angle
                false); -- tile

end

function Renderer:RenderSky()
    skyx = -300 * self.camera.angle * (math.pi/180) / math.pi * 1.5
    self.sky:draw(skyx, 0)
    
    if skyx < -200 then
        self.sky:draw(skyx + 600, 0)
    end
end