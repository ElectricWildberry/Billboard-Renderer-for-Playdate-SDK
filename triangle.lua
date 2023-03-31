local pd <const> = playdate
local gfx <const> = pd.graphics

import "CoreLibs/crank"
import "CoreLibs/animator"

class('Billboard').extends(gfx.sprite)

function Billboard:init(x, y, z, w, h, camera, img)

    self.img = img --this is needed to show an image

    self.xpos = x 
    self.ypos = -y --y is negative due to how the playdate sprite coordinate system works
    self.zpos = z

    self.w, self.h = self.img:getSize() -- this only happens once (for computing's sake), which is why all animation sprites need to be the same size

    self.camera = renderer.camera -- reference to the camera (to get position and rotation)
    self.rad = 0
    self.pitch = 0 -- unused
    self.rot = 0
    self.piv = 0 -- unused

    self.drawx = 0 
    self.drawy = 0 --draw coordinates, drawz is for draw order
    self.drawz = 0

    self.drawSizeX = 0
    self.drawSizeY = 0

    self.s = 0 -- temporary variable for the draw scale (self.scale is unwritable)

    self.rotx = 0
    self.roty = 0 -- rotated positions, calculated from camera position and rotation
    self.rotz = 0

    table.insert(renderer.tri_queue, self) --inserts self into the global renderer

    --self:add()
    
end

function Billboard:update()

    --self:ShowSelf()

end

function Billboard:Order(rad) --this checks whether the object is within render distance, and if it's behind the camera
    self.rad = rad
    self.rotz = (self.zpos - self.camera.zpos) * math.cos(rad) + (self.xpos - self.camera.xpos) * math.sin(rad) + self.camera.zpos
    return (self.rotz < self.camera.zpos) and ((self.rotz - self.camera.zpos) > -400 and (self.rotz - self.camera.zpos) < 0)
end

function Billboard:CheckZ(rad) -- function to check whether the object is within the drawspace

    self.rotx = (self.xpos - self.camera.xpos) * math.cos(rad) - (self.zpos - self.camera.zpos) * math.sin(rad) + self.camera.xpos
    self.drawx = -200 * (self.rotx - self.camera.xpos) / math.abs(self.rotz - self.camera.zpos)

    if (self.drawx > 100) or (self.drawx < -100) then return false else return true end
    
end

function Billboard:ShowSelf()

    if not self:CheckZ(self.rad) then return end -- this saves a substantial amount of time
    
    self.roty = self.ypos

    self.drawy = 200 * (self.roty - self.camera.ypos) / math.abs(self.rotz - self.camera.zpos)
    self.drawz = self.rotz
    self.drawSizeX = (200 * (self.rotx + self.w - self.camera.xpos) / (self.rotz - self.camera.zpos)) - self.drawx
    self.drawSizeY = (200 * (self.roty + self.h - self.camera.ypos) / math.abs(self.rotz - self.camera.zpos)) - self.drawy
    
    self.s = self.drawSizeX / self.w

    self.img:drawScaled(self.drawx + 100 + self.drawSizeX/2, self.drawy + 60 - self.drawSizeY, -self.s)
    

end
