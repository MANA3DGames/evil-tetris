-- This is mainly a UI for the Difficulty Level screen
require "menu"

local _difficulty_delay = 0.0	-- delay time to prevent the player from clicking on one of the difficulty buttons by mistake
levelofDifficulty = "medium"	-- level of difficulty which decide the speed of the game and the spawn blocks

function difficulty_load()
	-- load the background image for the Difficulty Level screen
	levelImage = love.graphics.newImage("Images/level.jpg")

	-- Create 3 buttons for the difficulty levels by calling button_create() in menu.lua
	button_create("easy", 120, 200, "Easy", fontLarge)
	button_create("medium", 120, 250, "Medium", fontLarge)
	button_create("hard", 120, 300, "Hard", fontLarge)
	button_create("", 120, 350, "", fontLarge)
end

function difficulty_update(dt)
	-- save the position of the mouse to check the click and hover-over events
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	
	-- call button_check in menu.lua to check if the mouse is over one of the buttons
	button_check(mouseX,mouseY)
	
	-- if the player press Esc button this will quit to the windows
	if love.keyboard.isDown("escape") then
		love.event.push("quit")
	end
	
	-- enable and disable cheating mode
	if love.keyboard.isDown("f1") then
		block_enableCheat(true)
	elseif love.keyboard.isDown("f2") then
		block_enableCheat(false)
	end
end

function difficulty_startDelay()
	-- set the delay time to the current time
	_difficulty_delay = love.timer.getTime()
end

function difficulty_setGameDifficulty(difficulty)
	-- set the current difficulty level
	levelofDifficulty = difficulty
	
	-- set the speed of the game according to the current difficulty level
	if levelofDifficulty == "easy" then
		block_setMoveDownDelay(2.0)
	elseif levelofDifficulty == "medium" then
		block_setMoveDownDelay(1.3)
	elseif levelofDifficulty == "hard" then
		block_setMoveDownDelay(0.8)
	end
end

function difficulty_draw()
	-- draw the background image for the Difficulty Level screen
	love.graphics.draw(levelImage, 0, 0)
	-- Difficulty Level Title
	love.graphics.setFont(fontTitle)
	love.graphics.setColor(255,0,0)
	love.graphics.print( "Difficulty Level", 100, 100 )
	
	-- check first if the delay time has passed so we can draw the buttons
	if love.timer.getTime() > _difficulty_delay + 0.5 then
		button_draw();
	else
		love.graphics.setColor(255,255,255)
	end
	
	-- set the font and print the text that describe quit command
	love.graphics.setFont(fontSmall)
	love.graphics.print( "Press Esc to quit the game...", 100, 500 )
end


















