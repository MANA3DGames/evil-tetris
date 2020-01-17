require "class"

local _spawnX = 0				-- X position where the block will spawn
local _spawnY = 0				-- Y position where the block will spawn

local _inputDelay = 0.2			-- input delay
local _inputTimer = 0.0			-- input delay timer
local _inputRotateDelay = 0.2	-- rotate input delay
local _inputRotateTimer = 0.0	-- rotate input delay timer 
local _moveDownDelay = 0.5		-- move down delay
local _moveDownTimer = 0.0		-- move down delay timer

local _isMoving = false			-- enable moving and rendering of the blocks
local _isCheating = false		-- Enable cheat mode

-- enum BlockID
blockID_Square = 0 		-- O or square shape
blockID_Leftgun = 1 	-- J or leftgun shape
blockID_Rightgun = 2	-- L or rightgun shape
blockID_Dash = 3 		-- I or dash shape
blockID_Leftsnake = 4	-- Z or leftsnake shape
blockID_Rightsnake = 5	-- S or rightsnake shape
blockID_Tee = 6			-- T or tee shape
----------------------------------------------------------
-- Cell Class
-- a cell is a data type that will represent the blocks element 
-- which will have a position X,Y
----------------------------------------------------------
Cell = class:new()

function Cell:init(xPos, yPos)
	-- set the x,y position for the cell inside the blocks 
	self.x = xPos
	self.y = yPos
end

function Cell:setPosition(xPos, yPos)
	-- set the x,y position for the cell inside the blocks 
	self.x = xPos
	self.y = yPos
end
----------------------------------------------------------
-- Block Class
-- a block is data that will represent the falling blocks
-- which will holds 4 cells (blocks)
----------------------------------------------------------
Block = class:new()

function Block:init() -- Just default values like a constructor
	-- BlockID
	self.blockID = blockID_Square
	
	-- RotateState	(0-3) this will represent the 4 states of the rotation
	self.rotateState = 0
	
	-- Texture
	self.texture = greenPiece
	
	-- create four cells (blocks)
	self.c1 = Cell:new()
	self.c1:init(0,0)
	self.c2 = Cell:new()
	self.c2:init(cellSize,0)
	self.c3 = Cell:new()
	self.c3:init(0,cellSize)
	self.c4 = Cell:new()
	self.c4:init(cellSize,cellSize)
	
	-- set boundaries for the block
	self.leftBoundary = 0
	self.rightBoundary = 0
	self.downBoundary = 0
end

function Block:setupSquare()
	-- Setup the Square Block
	self.blockID = blockID_Square
	self.rotateState = 0
	self.texture = greenPiece
	
	self.c1:setPosition(_spawnX,_spawnY)
	self.c2:setPosition(_spawnX + cellSize,_spawnY)
	self.c3:setPosition(_spawnX,_spawnY + cellSize)
	self.c4:setPosition(_spawnX + cellSize,_spawnY + cellSize)
	
	self.leftBoundary = self.c1.x
	self.rightBoundary = self.c2.x
	self.downBoundary = self.c3.y
end

function Block:setupLeftGun()
	-- Setup the Leftgun Block
	self.blockID = blockID_Leftgun
	self.rotateState = 0
	self.texture = bluePiece
	
	self.c1:setPosition(_spawnX - cellSize,_spawnY)
	self.c2:setPosition(_spawnX,_spawnY)
	self.c3:setPosition(_spawnX + cellSize,_spawnY)
	self.c4:setPosition(_spawnX + cellSize,_spawnY + cellSize)
	
	self.leftBoundary = self.c1.x
	self.rightBoundary = self.c3.x
	self.downBoundary = self.c4.y
end

function Block:setupRightGun()
	-- Setup the Rightgun Block
	self.blockID = blockID_Rightgun
	self.rotateState = 0
	self.texture = cyanPiece
	
	self.c1:setPosition(_spawnX - cellSize,_spawnY)
	self.c2:setPosition(_spawnX,_spawnY)
	self.c3:setPosition(_spawnX + cellSize,_spawnY)
	self.c4:setPosition(_spawnX - cellSize,_spawnY + cellSize)
	
	self.leftBoundary = self.c1.x
	self.rightBoundary = self.c3.x
	self.downBoundary = self.c4.y
end

function Block:setupDash()
	-- Setup the Dash Block
	self.blockID = blockID_Dash
	self.rotateState = 0
	self.texture = orangePiece
	
	self.c1:setPosition(_spawnX - cellSize,_spawnY)
	self.c2:setPosition(_spawnX,_spawnY)
	self.c3:setPosition(_spawnX + cellSize,_spawnY)
	self.c4:setPosition(_spawnX + (2 * cellSize),_spawnY)
	
	self.leftBoundary = self.c1.x
	self.rightBoundary = self.c4.x
	self.downBoundary = self.c1.y
end

function Block:setupLeftSnake()
	-- Setup the Leftsnake Block
	self.blockID = blockID_Leftsnake
	self.rotateState = 0
	self.texture = redPiece
	
	self.c1:setPosition(_spawnX - cellSize,_spawnY)
	self.c2:setPosition(_spawnX,_spawnY)
	self.c3:setPosition(_spawnX,_spawnY + cellSize)
	self.c4:setPosition(_spawnX + cellSize,_spawnY + cellSize)
	
	self.leftBoundary = self.c1.x
	self.rightBoundary = self.c4.x
	self.downBoundary = self.c4.y
end

function Block:setupRightSnake()
	-- Setup the Rightsnake Block
	self.blockID = blockID_Rightsnake
	self.rotateState = 0
	self.texture = violetPiece
	
	self.c1:setPosition(_spawnX,_spawnY)
	self.c2:setPosition(_spawnX + cellSize,_spawnY)
	self.c3:setPosition(_spawnX - cellSize,_spawnY + cellSize)
	self.c4:setPosition(_spawnX,_spawnY + cellSize)
	
	self.leftBoundary = self.c3.x
	self.rightBoundary = self.c2.x
	self.downBoundary = self.c4.y
end

function Block:setupTee()
	-- Setup the Tee Block
	self.blockID = blockID_Tee
	self.rotateState = 0
	self.texture = yellowPiece
	
	self.c1:setPosition(_spawnX - cellSize,_spawnY)
	self.c2:setPosition(_spawnX,_spawnY)
	self.c3:setPosition(_spawnX + cellSize,_spawnY)
	self.c4:setPosition(_spawnX,_spawnY + cellSize)
	
	self.leftBoundary = self.c1.x
	self.rightBoundary = self.c3.x
	self.downBoundary = self.c4.y
end

-- This is going to use as the holder of the 4 falling blocks (cells) 
-- this will be re-used for each spawn
block1 = Block:new()
----------------------------------------------------------

function block_load()
	-- where the block will be spawned in the scene
	_spawnX = start_XPos + ((xSize * cellSize)/2) - cellSize
	_spawnY = cellSize * -2
	
	-- initialize the block wit default values 
	block1:init()
end

function block_setMoveDownDelay(delay)
	-- set the delay to the current time
	_moveDownDelay = delay
end

function block_resetBlock()
	-- Stop moving and rendering the blocks
	_isMoving = false
end

--tempID = 0
function block_spawn(id)
	-- spawn a specific block shape according the id
	if id == blockID_Square then
		block1:setupSquare()
	elseif id == blockID_Leftgun then
		block1:setupLeftGun()
	elseif id == blockID_Rightgun then
		block1:setupRightGun()
	elseif id == blockID_Dash then
		block1:setupDash()
	elseif id == blockID_Leftsnake then
		block1:setupLeftSnake()
	elseif id == blockID_Rightsnake then
		block1:setupRightSnake()
	elseif id == blockID_Tee then
		block1:setupTee()
	end
	
	-- now we can start moving and rendering the blocks
	_isMoving = true
	
	--tempID = id
end

function block_enableCheat(enable)
	-- check if the cheat mode is enabled or not
	if _isCheating == enable then
		return
	end
	
	-- if the cheat mode is disabled enable it otherwise disable it
	_isCheating = enable
	
	-- play cheat SFX
	if _isCheating == true then
		-- call audio_playCheatSFX in audioManager.lua
		audio_playCheatSFX()
	end
end

function block_update(dt)
	-- Cheating
	if _isCheating == true then
		board_getCheatInput()
	end
	------------
	-- go back if the block is not allowed to move
	if _isMoving == false then
		return
	end
	
	-- move down the block automatically each amount of time (depends on the speed of the game)
	if love.timer.getTime() > _moveDownTimer + _moveDownDelay then 
		block_moveDown()
		-- set the delay to the current time
		_moveDownTimer = love.timer.getTime()
	end
	
	-- get the horizontal and the vertical input to move the blocks around
	if love.timer.getTime() > _inputTimer + _inputDelay then 
		if love.keyboard.isDown("right") then
			block_inputMoveHorizontal(cellSize)
		elseif love.keyboard.isDown("left") then
			block_inputMoveHorizontal(-cellSize)
		elseif love.keyboard.isDown("down") then
			block_inputMoveDown()
		end
	end
	
	-- get the rotate input (we need the special delay for the rotate input)
	if love.timer.getTime() > _inputRotateTimer + _inputRotateDelay then 
		if love.keyboard.isDown(" ") or love.keyboard.isDown("up") then
			block_rotate()
		end
	end
	
end

function board_getCheatInput()
	-- cheat Input
	if love.keyboard.isDown("1") then
		block_spawn(0)	-- will spawn Square
	elseif love.keyboard.isDown("2") then
		block_spawn(1)	-- will spawn Leftgun
	elseif love.keyboard.isDown("3") then
		block_spawn(2)	-- will spawn Rightgun
	elseif love.keyboard.isDown("4") then
		block_spawn(3)	-- will spawn Dash
	elseif love.keyboard.isDown("5") then
		block_spawn(4)	-- will spawn Leftsnake
	elseif love.keyboard.isDown("6") then
		block_spawn(5)	-- will spawn Rightsnake
	elseif love.keyboard.isDown("7") then
		block_spawn(6)	-- will spawn Tee
	end
end


function block_moveDown()
	-- first check if the positions are available (empty) before moving the blocks
	if block1.downBoundary + cellSize < downBoardBoundaryLimit and
	board_isValidCell(block1.c1.x,block1.c1.y + cellSize) == true and
	board_isValidCell(block1.c2.x,block1.c2.y + cellSize) == true and
	board_isValidCell(block1.c3.x,block1.c3.y + cellSize) == true and
	board_isValidCell(block1.c4.x,block1.c4.y + cellSize) == true then
		-- now its safe to move the blocks down
		block1.c1.y = block1.c1.y + cellSize
		block1.c2.y = block1.c2.y + cellSize
		block1.c3.y = block1.c3.y + cellSize
		block1.c4.y = block1.c4.y + cellSize
		-- set the new boundary for the blocks
		block1.downBoundary = block1.downBoundary + cellSize
	else
		-- stop moving and rendering the blocks
		_isMoving = false
		-- this mean the block has landed then we need to add it to the board
		board_addToBoard(block1)
	end

end

function block_inputMoveHorizontal(direction)
	-- return if the block is not moving
	if _isMoving == false then 
		_inputTimer = love.timer.getTime()
		return
	end
	
	-- first check the general boundary of the board
	if ( direction < 0 and block1.leftBoundary > leftBoardBoundaryLimit ) or 
	( direction > 0 and block1.rightBoundary < rightBoardBoundaryLimit ) then
		-- then check whether its an a valid place to go to not
		if board_isValidCell(block1.c1.x + direction, block1.c1.y) == true and
		board_isValidCell(block1.c2.x + direction, block1.c2.y) == true and
		board_isValidCell(block1.c3.x + direction, block1.c3.y) == true and
		board_isValidCell(block1.c4.x + direction, block1.c4.y) == true then
			-- Move the blocks now
			block1.c1.x = block1.c1.x + direction
			block1.c2.x = block1.c2.x + direction
			block1.c3.x = block1.c3.x + direction
			block1.c4.x = block1.c4.x + direction
			
			-- Update the boundary for the block1 
			block1.rightBoundary = block1.rightBoundary + direction
			block1.leftBoundary = block1.leftBoundary + direction
		end
		-- set the delay to the current time
		_inputTimer = love.timer.getTime()
	end
	
end

function block_inputMoveDown()
	-- return if the block is not moving
	if _isMoving == false then 
		_inputTimer = love.timer.getTime()
		return
	end
	
	-- first check the general boundary of the board -- then check whether its an a valid place to go to not
	if block1.downBoundary + cellSize < downBoardBoundaryLimit and
	board_isValidCell(block1.c1.x,block1.c1.y + cellSize) == true and
	board_isValidCell(block1.c2.x,block1.c2.y + cellSize) == true and
	board_isValidCell(block1.c3.x,block1.c3.y + cellSize) == true and
	board_isValidCell(block1.c4.x,block1.c4.y + cellSize) == true then
		block1.c1.y = block1.c1.y + cellSize
		block1.c2.y = block1.c2.y + cellSize
		block1.c3.y = block1.c3.y + cellSize
		block1.c4.y = block1.c4.y + cellSize
		-- Update the boundary for the block1 
		block1.downBoundary = block1.downBoundary + cellSize
	end
	-- set the delay to the current time
	_inputTimer = love.timer.getTime()
end


function block_rotate()
	-- return if the block is not moving
	if _isMoving == false then
		_inputRotateTimer = love.timer.getTime()
		return
	end
	
	-- this will be used to decide whether to play rotate SFX or error SFX
	local wasRotated = false
	
	if block1.blockID == blockID_Square then
		wasRotated = block_rotateSquare()
	elseif block1.blockID == blockID_Leftgun then
		wasRotated = block_rotateLeftgun()
	elseif block1.blockID == blockID_Rightgun then
		wasRotated = block_rotateRightgun()
	elseif block1.blockID == blockID_Dash then
		wasRotated = block_rotateDash()
	elseif block1.blockID == blockID_Leftsnake then
		wasRotated = block_rotateLeftsnake()
	elseif block1.blockID == blockID_Rightsnake then
		wasRotated = block_rotateRightsnake()
	elseif block1.blockID == blockID_Tee then
		wasRotated = block_rotateTee()
	end
	
	-- play the right SFX according to wasRotated value
	if wasRotated == true then
		audio_playRotateSFX()
	else
		audio_playErrorSFX()
	end
	
	-- set the delay to the current time
	_inputRotateTimer = love.timer.getTime()
end

function block_rotateSquare()
	-- there is no rotation for the Square shape
	return false
end

function block_rotateLeftgun()
	
	if block1.rotateState == 0 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x
		local c1_Y = block1.c2.y - cellSize
		local c2_X = block1.c2.x
		local c2_Y = block1.c2.y + cellSize
		local c3_X = block1.c2.x - cellSize
		local c3_Y = block1.c2.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c4.x
			block1.rightBoundary = block1.c3.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 1
			block1.rotateState = 1
		
			return true
		else
			return false
		end
	elseif block1.rotateState == 1 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x + cellSize
		local c1_Y = block1.c2.y
		local c2_X = block1.c2.x - cellSize
		local c2_Y = block1.c2.y
		local c3_X = block1.c2.x - cellSize
		local c3_Y = block1.c2.y - cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c3.x
			block1.rightBoundary = block1.c1.x
			block1.downBoundary = block1.c3.y
			
			-- rotate to state 2
			block1.rotateState = 2
			return true
		else
			return false
		end
	elseif block1.rotateState == 2 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x
		local c1_Y = block1.c2.y + cellSize
		local c2_X = block1.c2.x
		local c2_Y = block1.c2.y - cellSize
		local c3_X = block1.c2.x + cellSize
		local c3_Y = block1.c2.y - cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c1.y
			
			-- rotate to state 3
			block1.rotateState = 3
			return true
		else
			return false
		end
	elseif block1.rotateState == 3 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x - cellSize
		local c1_Y = block1.c2.y
		local c2_X = block1.c2.x + cellSize
		local c2_Y = block1.c2.y
		local c3_X = block1.c2.x + cellSize
		local c3_Y = block1.c2.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c3.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 0
			block1.rotateState = 0
			return true
		else
			return false
		end
	end
	

end

function block_rotateRightgun()
	
	if block1.rotateState == 0 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x
		local c1_Y = block1.c2.y - cellSize
		local c2_X = block1.c2.x
		local c2_Y = block1.c2.y + cellSize
		local c3_X = block1.c2.x - cellSize
		local c3_Y = block1.c2.y - cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c4.x
			block1.rightBoundary = block1.c3.x
			block1.downBoundary = block1.c3.y
			
			-- rotate to state 1
			block1.rotateState = 1
		
			return true
		else
			return false
		end
	elseif block1.rotateState == 1 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x + cellSize
		local c1_Y = block1.c2.y
		local c2_X = block1.c2.x - cellSize
		local c2_Y = block1.c2.y
		local c3_X = block1.c2.x + cellSize
		local c3_Y = block1.c2.y - cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c3.x
			block1.rightBoundary = block1.c1.x
			block1.downBoundary = block1.c1.y
			
			-- rotate to state 2
			block1.rotateState = 2
			return true
		else
			return false
		end
	elseif block1.rotateState == 2 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x
		local c1_Y = block1.c2.y + cellSize
		local c2_X = block1.c2.x
		local c2_Y = block1.c2.y - cellSize
		local c3_X = block1.c2.x + cellSize
		local c3_Y = block1.c2.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c1.y
			
			-- rotate to state 3
			block1.rotateState = 3
			return true
		else
			return false
		end
	elseif block1.rotateState == 3 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x - cellSize
		local c1_Y = block1.c2.y
		local c2_X = block1.c2.x + cellSize
		local c2_Y = block1.c2.y
		local c3_X = block1.c2.x - cellSize
		local c3_Y = block1.c2.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c3.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 0
			block1.rotateState = 0
			return true
		else
			return false
		end
	end
	

end

function block_rotateDash()
	if block1.rotateState == 0 then
		-- first calculate new positions for the cells
		local c1_X = block1.c3.x
		local c1_Y = block1.c3.y - (2 * cellSize)
		local c2_X = block1.c3.x
		local c2_Y = block1.c3.y - cellSize
		local c3_X = block1.c3.x
		local c3_Y = block1.c3.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and 
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c2:setPosition(c2_X,c2_Y)
			--block1.c3:setPosition(,)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c4.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 1
			block1.rotateState = 1
			return true
		else
			return false
		end
	elseif block1.rotateState == 1 then
		-- first calculate new positions for the cells
		local c1_X = block1.c3.x - (2 * cellSize)
		local c1_Y = block1.c3.y
		local c2_X = block1.c3.x - cellSize
		local c2_Y = block1.c3.y
		local c3_X = block1.c3.x + cellSize
		local c3_Y = block1.c3.y
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and 
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c2:setPosition(c2_X,c2_Y)
			--block1.c3:setPosition(,)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c4.y

			-- rotate to state 0
			block1.rotateState = 0
			return true
		else
			return false
		end
	end
end

function block_rotateLeftsnake()
	if block1.rotateState == 0 then
		-- first calculate new positions for the cells
		local c1_X = block1.c3.x + cellSize
		local c1_Y = block1.c3.y - cellSize
		local c2_X = block1.c3.x + cellSize
		local c2_Y = block1.c3.y
		local c3_X = block1.c3.x
		local c3_Y = block1.c3.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and 
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c2:setPosition(c2_X,c2_Y)
			--block1.c3:setPosition(,)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c3.x
			block1.rightBoundary = block1.c1.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 1
			block1.rotateState = 1
			return true
		else
			return false
		end
	elseif block1.rotateState == 1 then
		-- first calculate new positions for the cells
		local c1_X = block1.c3.x - cellSize
		local c1_Y = block1.c3.y - cellSize
		local c2_X = block1.c3.x
		local c2_Y = block1.c3.y - cellSize
		local c3_X = block1.c3.x + cellSize
		local c3_Y = block1.c3.y 
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and 
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c2:setPosition(c2_X,c2_Y)
			--block1.c3:setPosition(,)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c4.y

			-- rotate to state 0
			block1.rotateState = 0
			return true
		else
			return false
		end
	end

end

function block_rotateRightsnake()
	if block1.rotateState == 0 then
		-- first calculate new positions for the cells
		local c1_X = block1.c4.x - cellSize
		local c1_Y = block1.c4.y - cellSize
		local c2_X = block1.c4.x - cellSize
		local c2_Y = block1.c4.y
		local c3_X = block1.c4.x
		local c3_Y = block1.c4.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and 
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c2:setPosition(c2_X,c2_Y)
			block1.c3:setPosition(c3_X,c3_Y)
			--block1.c4:setPosition()
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c3.y
			
			-- rotate to state 1
			block1.rotateState = 1
			return true
		else
			return false
		end
	elseif block1.rotateState == 1 then
		-- first calculate new positions for the cells
		local c1_X = block1.c4.x
		local c1_Y = block1.c4.y - cellSize
		local c2_X = block1.c4.x + cellSize
		local c2_Y = block1.c4.y - cellSize
		local c3_X = block1.c4.x - cellSize
		local c3_Y = block1.c4.y
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and 
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c2:setPosition(c2_X,c2_Y)
			block1.c3:setPosition(c3_X,c3_Y)
			--block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c3.x
			block1.rightBoundary = block1.c2.x
			block1.downBoundary = block1.c4.y

			-- rotate to state 0
			block1.rotateState = 0
			return true
		else
			return false
		end
	end

end

function block_rotateTee()
	if block1.rotateState == 0 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x
		local c1_Y = block1.c2.y - cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true then
			-- now we can rotate
			block1.c3:setPosition(c1_X,c1_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c3.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 1
			block1.rotateState = 1
		
			return true
		else
			return false
		end
	elseif block1.rotateState == 1 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x + cellSize
		local c1_Y = block1.c2.y
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true then
			-- now we can rotate
			block1.c4:setPosition(c1_X,c1_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 2
			block1.rotateState = 2
			return true
		else
			return false
		end
	elseif block1.rotateState == 2 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x
		local c1_Y = block1.c2.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c4.x
			block1.downBoundary = block1.c1.y
			
			-- rotate to state 3
			block1.rotateState = 3
			return true
		else
			return false
		end
	elseif block1.rotateState == 3 then
		-- first calculate new positions for the cells
		local c1_X = block1.c2.x - cellSize
		local c1_Y = block1.c2.y
		local c2_X = block1.c2.x + cellSize
		local c2_Y = block1.c2.y
		local c3_X = block1.c2.x 
		local c3_Y = block1.c2.y + cellSize
		
		-- check if these cells are valid ones
		if board_isValidCell(c1_X,c1_Y) == true and
		board_isValidCell(c2_X,c2_Y) == true and
		board_isValidCell(c3_X,c3_Y) == true then
			-- now we can rotate
			block1.c1:setPosition(c1_X,c1_Y)
			block1.c3:setPosition(c2_X,c2_Y)
			block1.c4:setPosition(c3_X,c3_Y)
			
			-- update the boundary 
			block1.leftBoundary = block1.c1.x
			block1.rightBoundary = block1.c3.x
			block1.downBoundary = block1.c4.y
			
			-- rotate to state 0
			block1.rotateState = 0
			return true
		else
			return false
		end
	end
	

end


function block_draw()
	-- before drawing the block check first if it is moving or not
	if _isMoving == true then
		love.graphics.draw(block1.texture, block1.c1.x, block1.c1.y )
		love.graphics.draw(block1.texture, block1.c2.x, block1.c2.y )
		love.graphics.draw(block1.texture, block1.c3.x, block1.c3.y )
		love.graphics.draw(block1.texture, block1.c4.x, block1.c4.y )
	end
	
	-- Just for debugging
	-- love.graphics.print( "Left : " .. block1.leftBoundary .. " Right : " .. block1.rightBoundary , 0,0)
	-- love.graphics.print( " tempID: " .. tempID, 0,500)	
	-- if _isMoving == true then
		-- love.graphics.print( " isMove: TURE" , 0,530)
	-- else
		-- love.graphics.print( " isMove: FALSE" , 0,530)
	-- end
end
























