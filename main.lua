myTexturePack=TexturePack.new("Images/BhPopupDemo.txt", "Images/BhPopupDemo.png")

mySceneManager=SceneManager.new({
		["StartScene"] = StartScene,
		["ForestScene"]= ForestScene,
		})
stage:addChild(mySceneManager)

mySceneManager:changeScene("StartScene", 0.5, SceneManager.moveFromRight)