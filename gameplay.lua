-- the gameplay depends on two main elements; Board (board.lua) and Block (block.lua)
require "board"

local _score = 0
local _pauseDelay = 0.0		-- small amount of time to delay the pause

function gameplay_load()
	-- load the background image for the Gameplay scene
	bgImage = love.graphics.newImage("Images/gameplay.jpg")
	-- load mask image which will be used as mask to cover the top part of the board where the Block comes from
	maskImage = love.graphics.newImage("Images/mask.jpg")
	
	-- load the board
	board_load()
end

function pause_setPauseDelay()
	-- set the pause delay to the current time 
	_pauseDelay = love.timer.getTime()
end

function gameplay_update(dt)
	
	-- check if the player press on the Esc key to pause the game
	if love.timer.getTime() > _pauseDelay + 0.3 and love.keyboard.isDown("escape") then
		-- call the game_pause Func inside game.lua
		game_pause()
		return
	end
	
	-- update the board
	board_update(dt)
end

function resetScore()
	_score = 0
end

function updateScore(val)
	_score = _score + val
end

function gameplay_draw()
	-- draw the background image for the Gameplay scene
	love.graphics.draw(bgImage, 0, 0)
	-- draw the board
	board_draw()
	-- draw the ,mask above the background image
	love.graphics.draw(maskImage, 45, -5)
	
	-- Difficulty level
	love.graphics.setFont(fontLarge)
	if levelofDifficulty == "easy" then
		love.graphics.setColor(0,255,0)
		love.graphics.print(levelofDifficulty, 530, 90 )
	elseif levelofDifficulty == "medium" then
		love.graphics.setColor(0,0,255)
		love.graphics.print(levelofDifficulty, 510, 90 )
	elseif levelofDifficulty == "hard" then
		love.graphics.setColor(255,0,0)
		love.graphics.print(levelofDifficulty, 530, 90 )
	end
	
	love.graphics.setColor(255,255,255)
	love.graphics.print( "Score: " .. _score, 500, 160 )
	
	-- print the pause instruction text
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(fontSmall)
	love.graphics.print("Press Esc to pause the game", 20, 560 )
end






















