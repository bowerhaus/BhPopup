StartScene=Core.class(Sprite)

function StartScene:doSomeLongLoadingThing()
	-- This method could be used to do a time comsuming operation while a "Loading..."
	-- boxd is displayed. Note that the loading is not performed in the background
	-- so we can't display any animations during this time.
end

function StartScene:onStartTouched(event)
	local loadingPopup=LoadingPopup.new({autoRunFunc=function() self:doSomeLongLoadingThing() end, minimumShowTime=2})
	loadingPopup:addEventListener("complete", 
		function() mySceneManager:changeScene("ForestScene", 0.5, SceneManager.moveFromRight) end)
end

function StartScene:init()
	local text=TextField.new(TTFont.new("Fonts/Tahoma.ttf", 40), "Touch to Start")
	text:setPosition((application:getContentWidth()-text:getWidth())/2, application:getContentHeight()/2)
	self:addEventListener(Event.MOUSE_UP, self.onStartTouched, self)
	self:addChild(text)
end