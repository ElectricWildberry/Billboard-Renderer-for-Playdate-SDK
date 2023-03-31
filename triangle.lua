local pd <const> = playdate
local gfx <const> = pd.graphics

import "CoreLibs/crank"
import "CoreLibs/animator"

class('Triangle').extends(gfx.sprite)

function Triangle:init(x, y, z, w, h, camera, img)

    self.disabled = false

    self.img = img

    self.xpos = x
    self.ypos = -y
    self.zpos = z

    self.w, self.h = self.img:getSize()

    self.camera = renderer.camera
    self.rad = 0
    self.pitch = 0
    self.rot = 0
    self.piv = 0

    self.drawx = 0
    self.drawy = 0
    self.drawz = 0

    self.drawSizeX = 0
    self.drawSizeY = 0

    self.s = 0

    self.rotx = 0
    self.roty = 0
    self.rotz = 0

    self.pic = nil

    table.insert(renderer.tri_queue, self)

    --self:add()
    
end

function Triangle:update()

    --self:ShowSelf()

end

function Triangle:Order(rad)
    self.rad = rad
    self.rotz = (self.zpos - self.camera.zpos) * math.cos(rad) + (self.xpos - self.camera.xpos) * math.sin(rad) + self.camera.zpos
    return (self.rotz < self.camera.zpos) and ((self.rotz - self.camera.zpos) > -400 and (self.rotz - self.camera.zpos) < 0)
end

function Triangle:CheckZ(rad)

    --if self.disabled then return false end

    self.rotx = (self.xpos - self.camera.xpos) * math.cos(rad) - (self.zpos - self.camera.zpos) * math.sin(rad) + self.camera.xpos
    --self.rotz = (self.zpos - self.camera.zpos) * math.cos(rad) + (self.xpos - self.camera.xpos) * math.sin(rad) + self.camera.zpos
    self.drawx = -200 * (self.rotx - self.camera.xpos) / math.abs(self.rotz - self.camera.zpos)

    if (self.drawx > 100) or (self.drawx < -100) then return false else return true end

    --return true

    --return (self.rotz < self.camera.zpos) and (math.abs(self.rotz - self.camera.zpos) < 300)
end

function Triangle:ShowSelf()

    if not self:CheckZ(self.rad) then return end

    --self.rotx = (self.xpos - self.camera.xpos) * math.cos(rad) - (self.zpos - self.camera.zpos) * math.sin(rad) + self.camera.xpos
    self.roty = self.ypos
    --self.rotz = (self.zpos - self.camera.zpos) * math.cos(rad) + (self.xpos - self.camera.xpos) * math.sin(rad) + self.camera.zpos

    --self.drawx = -400 * (self.rotx - self.camera.xpos) / math.abs(self.rotz - self.camera.zpos)
    self.drawy = 200 * (self.roty - self.camera.ypos) / math.abs(self.rotz - self.camera.zpos)
    self.drawz = self.rotz
    self.drawSizeX = (200 * (self.rotx + self.w - self.camera.xpos) / (self.rotz - self.camera.zpos)) - self.drawx
    self.drawSizeY = (200 * (self.roty + self.h - self.camera.ypos) / math.abs(self.rotz - self.camera.zpos)) - self.drawy
    
    self.s = self.drawSizeX / self.w

    self.img:drawScaled(self.drawx + 100 + self.drawSizeX/2, self.drawy + 60 - self.drawSizeY, -self.s)
    

end