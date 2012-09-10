--[[ 
BhPopup.lua

A popup class for ovelaying a modal popup display over an existing scene.
Typically you will subclass new class for each popup that you create. You can either handle all user interaction
within your popup class or you can specify an (autoRunFunc) that will be automatically be executed as soon at the popup
has been loaded. When the (autoRunFunc) completes the popup will dismiss itself as if by magic.
 
MIT License
Copyright (C) 2012. Andy Bower, Bowerhaus LLP

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

BhPopup=Core.class(Sprite)

-- Transitions derived from the original Gideros SceneManager.

function BhPopup:fade()
	self:setAlpha(0)
	return {alpha=1}
end

function BhPopup:overFromRight()
	local x=self:getX()
	self:setX(x+application:getContentWidth())
	return {x=x}
end
BhPopup.overToRight=BhPopup.overFromFromRight

function BhPopup:overFromLeft()
	local x=self:getX()
	self:setX(x-application:getContentWidth())
	return {x=x}
end
BhPopup.overToLeft=BhPopup.overFromLeft

function BhPopup:overFromTop()
	local y=self:getY()
	self:setY(y-application:getContentHeight())
	return {y=y}
end
BhPopup.overToTop=BhPopup.overFromTop

function BhPopup:overFromBottom()
	local y=self:getY()
	self:setY(y+application:getContentHeight())
	return {y=y}
end
BhPopup.overToBottom=BhPopup.overFromBottom

local TRANSITION_DELAY_MS=10
local MINIMUM_TRANSITION_DURATION=0.2
local DEFAULT_TRANSITION=BhPopup.fade
local DEFAULT_MINIMUM_SHOWTIME=1
local QUEUED_FUNCTION_FRAME_DELAY=5

function BhPopup:onAddedToStage()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function BhPopup:onRemovedFromStage()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function BhPopup:onEnterFrame()
	if self.queuedFunc then
		self.queuedFuncCount=self.queuedFuncCount-1
		if self.queuedFuncCount<=0 then
			self:queuedFunc()
			self.queuedFunc=nil
		end
	end
end

function BhPopup:onEnterBegin()	
	self:setVisible(true)
	self:dispatchEvent(Event.new("enterBegin"))
end

function BhPopup:onEnterEnd()
	self:dispatchEvent(Event.new("enterEnd"))
	if self.autoRunFunc then
		self.autoRunFunc()
		local time1=os.timer()
		local timeElapsed=time1-self.time0
		local timeRemaining=math.max(0, self.minimumShowTime-timeElapsed)
		Timer.delayedCall(timeRemaining*1000, function() 
			self.queuedFunc=self.exit 
			self.queuedFunccCount=5
			end, self)
	end
end

function BhPopup:onExitBegin()
	self:dispatchEvent(Event.new("exitBegin"))
end

function BhPopup:onExitEnd()
	self:removeFromParent()
	self:dispatchEvent(Event.new("exitEnd"))
	self:dispatchEvent(Event.new("complete"))
end

function BhPopup:enter()
	self:onEnterBegin()
	local tween=GTween.new(self, self.enterExitDuration, self:enterTransition(), {ease=self.enterEasing, dispatchEvents=true})
	tween:addEventListener("complete", self.onEnterEnd, self)
end

function BhPopup:exit()
	self:onExitBegin()
	local tween=GTween.new(self, self.enterExitDuration, self:exitTransition(), {ease=self.exitEasing, dispatchEvents=true, swapValues=true})
	tween:addEventListener("complete", self.onExitEnd, self)
end

function BhPopup:queueCall(func)
	self.queuedFunc=self.enter
	self.queuedFuncCount=QUEUED_FUNCTION_FRAME_DELAY
end

function BhPopup:ignoreTouchHandler(event)
	event:stopPropagation()
end

function BhPopup:ignoreTouches()
	-- Tell a sprite to ignore (and block) all mouse and touch events
	self:addEventListener(Event.MOUSE_DOWN, self.ignoreTouchHandler, self)
	self:addEventListener(Event.TOUCHES_BEGIN, self.ignoreTouchHandler, self)
end

function BhPopup:init(options)
	options=options or{}
	self.time0=os.timer()
	self.minimumShowTime=options.minimumShowTime or DEFAULT_MINIMUM_SHOWTIME
	self.enterExitDuration=math.max(options.enterExitDuration or 0, MINIMUM_TRANSITION_DURATION)
	self.enterTransition=options.enterTransition or DEFAULT_TRANSITION
	self.enterEasing=options.enterEasing or easing.linear
	self.exitTransition=options.exitTransition or self.enterTransition
	self.exitEasing=options.exitEasing or self.enterEasing
	self.autoRunFunc=options.autoRunFunc
	
	-- Delay the enter() call to allow any subclasses to perform their setup first
	self:queueCall(self.enter)
	
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)

	self:setVisible(false)
	self:ignoreTouches()
	stage:addChild(self)
end