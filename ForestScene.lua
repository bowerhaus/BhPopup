ForestScene=Core.class(Sprite)

function ForestScene:onMouseUp(event)
	for k, v in pairs(self.animals) do
		if v:hitTestPoint(event.x, event.y) then
			AnimalPopup.new({enterTransition=BhPopup.overFromBottom, enterExitDuration=0.5}, k)
			event:stopPropagation()
		end
	end
end

function ForestScene:init()
	local bg=Bitmap.new(myTexturePack:getTextureRegion("CastleBackground.png"))
	self:addChild(bg)
	self.animals={}
	
	local bear=Bitmap.new(myTexturePack:getTextureRegion("Bear.png"))
	bear:setAnchorPoint(0.5, 0.5)
	bear:setPosition(550, 575)
	bear:setScale(0.9)
	self:addChild(bear)
	self.animals["Bear"]=bear
	
	local butterfly=Bitmap.new(myTexturePack:getTextureRegion("Butterfly.png"))
	butterfly:setAnchorPoint(0.5, 0.5)
	butterfly:setScale(0.25)
	butterfly:setPosition(800, 220)
	self:addChild(butterfly)
	self.animals["Butterfly"]=butterfly
	
	local owl=Bitmap.new(myTexturePack:getTextureRegion("Owl.png"))
	owl:setAnchorPoint(0.5, 0.5)
	owl:setScale(0.5)
	owl:setPosition(280, 260)
	self:addChild(owl)
	self.animals["Owl"]=owl
		
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end