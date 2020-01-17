-- We need to use AnAL.lua to play some animation
require("AnAL")

local _resumeDelay = 0.0		-- small amount of delay for the resume input

function pause_load()
	-- Load the animation source. which a jpg image
	faceAnimImg  = love.graphics.newImage("Images/faceAnim.jpg")
	-- Create animation.
	faceAnim = newAnimation(faceAnimImg, 256, 256, 0.1, 0)
end

function pause_setResumeDelay()
	-- set the delay to the current time
	_resumeDelay = love.timer.getTime()
end

function pause_update(dt)
	-- check if the player press on Esc key to resume the game
	if love.timer.getTime() > _resumeDelay + 0.5 and love.keyboard.isDown("escape") then
		-- call game_resume in game.lua
		game_resume(dt)
	end
	
	-- check if the player press on F5 key to start a new game
	if love.timer.getTime() > _resumeDelay + 0.5 and love.keyboard.isDown("f5") then
		-- call game_startNewGame func in game.lua
		game_startNewGame()
	end
	
	-- Updates the face animation. (Enables frame changes)
	faceAnim:update(dt) 
	
end

function pause_draw()
	-- print Game Paused text as a title for the screen 
	love.graphics.setFont(fontLarge)
	love.graphics.print("Game Paused", 250, 100)
	
	-- Draw the animation at (250, 200).
   faceAnim:draw(250, 200) 
   
   -- print the text for the commands (Esc) and F5
   love.graphics.setFont(fontSmall)
   love.graphics.print("Press Esc to resume the game", 210, 510)
   love.graphics.print("Press F5 to start a new game", 210, 540)
end