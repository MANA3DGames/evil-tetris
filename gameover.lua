
local _restartDelay = 0.0		-- small amount of the time to delay the restart input

function gameover_load()
	-- maybe will add a background image later!
end

function pause_setRestartDelay()
	-- set the delay to the current time
	_restartDelay = love.timer.getTime()
end

function gameover_update(dt)

	-- Moved to game.lua -> love.keypressed(key) && gameover_canWeStartANewGame()
	-- -- check if the player press F5 to start a new game
	-- if love.timer.getTime() > _restartDelay + 0.3 and love.keyboard.isDown("f5") then
		-- -- call game_startNewGame in game.lua to move back to the Difficulty Level screen
		-- game_startNewGame()
	-- end
	
	-- Updates the face animation. (Enables frame changes)
	faceAnim:update(dt) 
	
end

function gameover_canWeStartANewGame()
	if love.timer.getTime() > _restartDelay + 0.5 then
		return true
	else
		return false
	end
end

function gameover_draw()
	-- print Game Over! text as a title
	love.graphics.setFont(fontLarge)
	love.graphics.print("Game Over!", 260, 100)
	
	-- Draw the animation at (250, 200).
   faceAnim:draw(250, 200)
   
   -- print the instruction
   love.graphics.setFont(fontSmall)
   love.graphics.print("Press any key to start a new game", 180, 510)
end



