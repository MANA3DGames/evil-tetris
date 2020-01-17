require "title"
require "difficulty"
require "audioManager"
require "gameplay"
require "pause"
require "gameover"

-- enum State 
state_title = 0
state_difficulty = 1
state_gameplay = 2
state_pause = 3
state_gameover = 4
----------------------------------------------------------

-- We need to know the current state of the game by using a State enum (kinda enum!)
local _gameState = state_title

function game_load()
	-- load all the game's components here
	title_load()
	difficulty_load()
	audio_load()
	gameplay_load()
	pause_load()
	gameover_load()
end

function game_update(dt)
	-- This will update the whole game/ according to the current state of the game
	if _gameState == state_title then
		title_update(dt)
	elseif _gameState == state_difficulty then
		difficulty_update(dt)
	elseif _gameState == state_gameplay then
		gameplay_update(dt)
	elseif _gameState == state_pause then
		pause_update(dt)
	elseif _gameState == state_gameover then
		gameover_update(dt)
	end
end

function love.keypressed(key)
	-- if we are on the Title screen we need to check for any input to start the game 
	-- so we use keypressed() function because we don't care about the key
	if _gameState == state_title then
		-- play the start SFX in the audioManager.lua
		audio_playStartSFX()
		-- set a small delay to make the difficulty buttons appears after small amount of time
		-- because we don't want the player to click on of them by mistake
		difficulty_startDelay()
		-- as we are going to the Difficulty Level screen we need to update the current state to state_difficulty
		_gameState = state_difficulty
	elseif _gameState == state_gameover then
	--to move back to the Difficulty Level screen
		if gameover_canWeStartANewGame() == true then
			game_startNewGame()
		end
	end
end

function love.mousepressed(x, y, button)
	-- if we are on the Title screen we need to check for any input to start the game 
	-- so we also use mousepressed() function
	if _gameState == state_title then
		-- play the start SFX in the audioManager.lua
		audio_playStartSFX()
		-- set a small delay to make the difficulty buttons appears after small amount of time
		-- because we don't want the player to click on of them by mistake
		difficulty_startDelay()
		-- as we are going to the Difficulty Level screen we need to update the current state to state_difficulty
		_gameState = state_difficulty
	end
end

function love.mousereleased(x, y, button)
	-- Get the left click for the mouse
   if button == "l" then
	-- if we are in the Difficulty Level screen and the player click the left mouse button
	-- inside the menu.lua will go through and array of buttons to check if one of them has been clicked
	-- to decide the difficulty of the game then to start a new game
	if _gameState == state_difficulty then
		-- call button_click fun inside menu lua
		button_click(x,y)
	end
   end
end

function game_start(difficulty)
	-- play click button SFX in the audioManager.lua
	audio_playClickSFX()
	-- set the difficulty level in difficulty.lua
	difficulty_setGameDifficulty(difficulty)
	-- now we will start a new game so we need to update the current state for the game
	_gameState = state_gameplay
	-- this will start spawning the blocks
	board_nextSpawn()
end

function game_startNewGame()
	-- restart a new game so we go back to Difficulty Level screen
	_gameState = state_difficulty
	-- clean the board and the falling blocks
	board_recreateBoard()
end

function game_pause()
	-- set a delay to the input so when the player go to the pause menu and press Esc again
	-- he won't be able to resume the game before small amount of time
	pause_setResumeDelay()
	-- we need to update the current state of the game to state_pause
	_gameState = state_pause
end

function game_resume()
	-- a small delay to prevent the player to go to pause menu immediately after being moved to the gameplay
	-- which could be happen by mistake by keep pressing on Esc
	pause_setPauseDelay()
	-- upate the current state to gameplay
	_gameState = state_gameplay
end

function game_over()
	-- play game over SFX in audioManager.lua 
	audio_playGameOverSFX()
	-- update the current state
	_gameState = state_gameover
end

function game_draw()
	-- This will draw all the components for the whole game / according to the current state of the game
	if _gameState == state_title then
		title_draw()
	elseif _gameState == state_difficulty then
		difficulty_draw()
	elseif _gameState == state_gameplay then
		gameplay_draw()
	elseif _gameState == state_pause then
		pause_draw()
	elseif _gameState == state_gameover then
		gameover_draw()
	end
end










