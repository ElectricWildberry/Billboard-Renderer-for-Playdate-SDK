local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

import "UI/MechUI"
import "Weapons/Bullet"
import "Mech/MechWeaponSystem"

class('Camera').extends(gfx.sprite)

function Camera:init(x, y, z)

    self:moveTo(x, z)

    --collision
    self:setCollideRect(-10, -10, 20, 20)
	self.collisionResponse = 'slide'
	self:setCollidesWithGroups({4})
    --collision

    --aiming
    self.currentDir = geo.vector2D.new(0, 0)
    self.dirRight = geo.vector2D.new(0, 0)
    self.input = geo.vector2D.new(0, 0)
    --aiming

    --rendering
    self.xpos = x
    self.ypos = y
    self.zpos = z

    self.far = 400
    self.near = 10
    self.angle = 0
    --rendering

    --movement
    self.speed = 70
    --movement

    --shooting
    self.shotCooldown = 1
    self.currentCooldown = 0
    --shooting

    self.ui = MechUI()
    self.weapons = nil

    self:add()
    
end

function Camera:update()

    self:Move()
    self:Shoot()
    
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
        --self.zpos = self.zpos  - self.speed / pd.display.getRefreshRate() 
        self.input.dy = -1
        
        self.ui:animate()
    end

    if pd.buttonIsPressed(pd.kButtonDown) then
        --self.zpos = self.zpos + self.speed / pd.display.getRefreshRate()
        self.input.dy = 1

        self.ui:animate()
    end 

    if pd.buttonIsPressed(pd.kButtonRight) then
        --self.xpos = self.xpos + self.speed / pd.display.getRefreshRate()
        self.input.dx = 1

        self.ui:animate()
    end

    if pd.buttonIsPressed(pd.kButtonLeft) then
        --self.xpos = self.xpos - self.speed / pd.display.getRefreshRate()
        self.input.dx = -1

        self.ui:animate()
    end

    --local finalDir = geo.vector2D.new(0,0)

    self.currentDir:normalize()
    self.dirRight:normalize()
    self.input:normalize()

    self.zpos = self.zpos + (self.currentDir.dy * self.input.dy) * self.speed / rf
    self.xpos = self.xpos + (self.currentDir.dx * -self.input.dy) * self.speed / rf
    self.zpos = self.zpos + (self.dirRight.dy * self.input.dx) * self.speed / rf
    self.xpos = self.xpos + (self.dirRight.dx * self.input.dx) * self.speed / rf

    local actualX, actualY, collisions, length = self:moveWithCollisions(-self.xpos, self.zpos)

    self.zpos = actualY
    self.xpos = -actualX

end

function Camera:Shoot()

    if pd.buttonJustPressed(pd.kButtonA) then
        if not tb.showing then
            local sprites = gfx.sprite.querySpritesAlongLine(self.x, self.y, self.x - self.currentDir.dx * 100, self.y - self.currentDir.dy * 100)
            
            for index, hit in ipairs(sprites) do
                print(hit:getGroupMask())
                if hit.tag == "npc" then
                    hit:Speak()
                end
                if hit.tag == "Door" then
                    hit:Switch()
                end
            end
        end

    end

    self.currentCooldown -= 1 / pd.display.getRefreshRate()

end