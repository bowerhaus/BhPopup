require "BhPopup"

LoadingPopup=Core.class(BhPopup)

local w, h=application:getContentWidth(), application:getContentHeight()

function LoadingPopup:init()	
	local bg=Bitmap.new(myTexturePack:getTextureRegion("Loading.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(w/2, h/2)
	self:addChild(bg)	
end