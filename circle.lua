local pd <const> = playdate
local gfx <const> = pd.graphics

import "CoreLibs/crank"
import "CoreLibs/animator"

class('Circle').extends(gfx.sprite)

function Circle:init(x, y, z, size, camera)

    self.disabled = false

    self.xpos = x
    self.ypos = -y
    self.zpos = z

    self.size = size

    self.camera = renderer.camera
    self.pitch = 0
    self.rot = 0
    self.piv = 0

    self.drawx = x
    self.drawy = -y
    self.drawz = z

    self.rotx = 0
    self.roty = 0
    self.rotz = 0

    self.pic = nil

    table.insert(renderer.sphere_queue, self)

    --self:add()
    
end

function Circle:update()

    --self:ShowSelf()

end

function Circle:CheckZ(rad)

    if self.disabled then return false end

    self.rotx = (self.xpos - self.camera.xpos) * math.cos(rad) - (self.zpos - self.camera.zpos) * math.sin(rad) + self.camera.xpos
    self.rotz = (self.zpos - self.camera.zpos) * math.cos(rad) + (self.xpos - self.camera.xpos) * math.sin(rad) + self.camera.zpos
    self.drawx = -200 * (self.rotx - self.camera.xpos) / math.abs(self.rotz - self.camera.zpos)

    if (self.drawx > 200) or (self.drawx < -200) then return false end

    return (self.rotz < self.camera.zpos) and (math.abs(self.rotz - self.camera.zpos) < 300)

end

function Circle:ShowSelf(rad)

    --self.rotx = (self.xpos - self.camera.xpos) * math.cos(rad) - (self.zpos - self.camera.zpos) * math.sin(rad) + self.camera.xpos
    self.roty = self.ypos
    --self.rotz = (self.zpos - self.camera.zpos) * math.cos(rad) + (self.xpos - self.camera.xpos) * math.sin(rad) + self.camera.zpos

    --self.drawx = -400 * (self.rotx - self.camera.xpos) / math.abs(self.rotz - self.camera.zpos)
    self.drawy = 200 * (self.roty - self.camera.ypos) / math.abs(self.rotz - self.camera.zpos)
    self.drawz = self.rotz
    self.drawSize = (200 * (self.roty + self.size - self.camera.ypos) / math.abs(self.rotz - self.camera.zpos)) - self.drawy 

end