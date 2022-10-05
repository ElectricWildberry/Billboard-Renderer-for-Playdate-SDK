import "CoreLibs/object"

import "floor"
import "trajectory"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y, image)
	self:moveTo(x, y)
	--self:setImage(image)

	--collisions
	self:setCollideRect(0, 0, 8, 8)
	self.collisionResponse = 'overlap'
	self:setCollidesWithGroups({2, 3})

	--params
	self.xpos = x
	self.ypos = y
	self.input = pd.geometry.vector2D.new(0, 0)
	self.velocityX = 0
	self.velocityY = 0
	self.maxVelocityX = 5
	self.maxVelocityY = 30
	self.isGrounded = false

	self.moveSpeed = 0.1
	self.gravity = 25

	self.crankPos = pd.getCrankPosition()
	self.currentRotation = 0
	self.shipRotation = pd.geometry.vector2D.new(0, 0)

	self.trajectoryLine = Trajectory()

	self:add()
end

function Player:TakeInput()

	if pd.buttonIsPressed(pd.kButtonLeft) then
        self.input.dx = -1
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.input.dx = 1
	else
		self.input.dx = 0
	end

end

function Player:RotateVector()

	local newPos = self.crankPos - pd.getCrankPosition()
	self.crankPos = pd.getCrankPosition()

	if newPos > 0 then
		newPos = 3
	elseif newPos < 0 then
		newPos = -3
	end

	self.currentRotation += newPos

	local rad = self.currentRotation * (math.pi / 180)
	self.shipRotation = pd.geometry.vector2D.new(math.cos(rad), math.sin(rad))
	self.shipRotation:normalize()

	self.trajectoryLine:Rotate(self.x, self.y, self.currentRotation)

end

function Player:Move()

	--move linear based on input
	self.velocityX = self.shipRotation.dx * self.moveSpeed 
	self.velocityY = self.shipRotation.dy * self.moveSpeed

	print(self.velocityX, self.velocityY)

	--gravity
	if not self.isGrounded then
		--self.velocityY += self.gravity / 30
	end

	--velocity limit
	if self.velocityX > self.maxVelocityX then
		self.velocityX = self.maxVelocityX
	elseif self.velocityX < -self.maxVelocityX then
		self.velocityX = -self.maxVelocityX
	end

	if self.velocityY > self.maxVelocityY then
		self.velocityY = self.maxVelocityY
	end

	if math.abs(self.velocityX) < 0.05 then
		self.velocityX = 0
	end

	--move
	local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + self.velocityX, self.y + self.velocityY)
	if length > 0 then
		for index, collision in ipairs(collisions) do
			local collidedObject = collision['other']
			--print(collidedObject:isa(Floor))
			--self.isGrounded = true
		end
	end


end

function Player:update()
	Player.super.update(self)

	self:RotateVector()
	--self:TakeInput()
	self:Move()

end