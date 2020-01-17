require "block"

boardCells = {}						-- board table (array)
xSize, ySize = 10, 15				-- board dimensions
cellSize = 32						-- cell size (32x32)
start_XPos, start_YPos = 64, 32		-- start point for the broad
leftBoardBoundaryLimit = 0			-- the left boundary limit of the board
rightBoardBoundaryLimit = 0			-- the right boundary limit of the board
downBoardBoundaryLimit = 0			-- the down boundary limit of the board

linesTracer = {}					-- This will keep track of the number of filled spaces for each line.
topReachedLineIndex = 15			-- Reached line so far (15-1) 1 is the highest, 15 is the lowest line. 



function board_load()
	-- load all the texture that will be used for the blocks
	boardPiece = love.graphics.newImage("Images/Block_Gray.png")
	greenPiece = love.graphics.newImage("Images/Block_Green.png")
	bluePiece = love.graphics.newImage("Images/Block_Blue.png")
	cyanPiece = love.graphics.newImage("Images/Block_Cyan.png")
	orangePiece = love.graphics.newImage("Images/Block_Orange.png")
	redPiece = love.graphics.newImage("Images/Block_Red.png")
	violetPiece = love.graphics.newImage("Images/Block_Violet.png")
	yellowPiece = love.graphics.newImage("Images/Block_Yellow.png")
	
	-- create the board
	board_create()
	
	-- load the blocks
	block_load()
end

function board_recreateBoard()
	-- reset Player score / gameplay.lua
	resetScore()
	
	-- recreate the broad
	board_create()
	-- reset the falling block by calling block_resetBlock() inside block.lua
	block_resetBlock()
	
	-- reset values
	spawnCount = 0
	lastSpawnId = 0
	
	topReachedLineIndex = 15
	minEmptyLineIndex = 15
	-- Clear minLines table. 
	for k in pairs (minLines) do
		minLines[k] = nil
	end
	minLinesLastIndex = 1
end

function board_create()
	-- create the board cells and initialize them with position, empty value and defualt texture
	for i = 1, xSize do
		boardCells[i] = {}
		for j = 1, ySize do
			table.insert(boardCells[i], {xPos = start_XPos + cellSize*(i-1), yPos = start_YPos + cellSize*(j-1), empty = true, texture = boardPiece})
		end 
	end
	
	-- set the boundary limit of the board
	leftBoardBoundaryLimit = start_XPos
	rightBoardBoundaryLimit = boardCells[xSize][1].xPos
	downBoardBoundaryLimit = boardCells[1][ySize].yPos + cellSize
	
	
	-- create the linesTracer.
	for i = 1, ySize do
		-- Set empty spaces to 10 at the beginning because we have 10 columns
		linesTracer[i] = 10
	end
	
end

function board_update(dt)
	-- update the block inside block.lua
	block_update(dt)
end

function board_isValidCell(xPos, yPos)
	-- Just to get into the boundary of the board
	if yPos < start_YPos then
		return true
	end
	---------------------------------------------
	-- find a specific cell in the board to see whether it is empty or not
	for i = 1, xSize do
		for j = 1, ySize do
			if boardCells[i][j].xPos == xPos and 
			   boardCells[i][j].yPos == yPos then
			   if boardCells[i][j].empty == true then
					return true
				else
					return false
			   end
			end
		end
	end
	
	return false
	
end

function board_addToBoard(blocks)
	-- add the 4 landed blocks to the board
	board_fillCell(blocks.c1.x, blocks.c1.y, blocks.texture)
	board_fillCell(blocks.c2.x, blocks.c2.y, blocks.texture)
	board_fillCell(blocks.c3.x, blocks.c3.y, blocks.texture)
	board_fillCell(blocks.c4.x, blocks.c4.y, blocks.texture)
	
	-- Now we want to check if there is any complete row
	board_checkRows()
end

function board_fillCell(xPos, yPos, newTexture)
	-- First get the right cell, 
	for i = 1, xSize do
		for j = 1, ySize do
			if boardCells[i][j].xPos == xPos and 
			   boardCells[i][j].yPos == yPos then
			   
				-- then fill it with the new texture
				boardCells[i][j].texture = newTexture
				-- and set it empty value to false.
				boardCells[i][j].empty = false
			   
				-- Adjust number of empty spaces for this line.
				linesTracer[j] = linesTracer[j] - 1
			   
				-- Change topReachedLineIndex
				if j < topReachedLineIndex then
					topReachedLineIndex = j
				end
			
				-- if the filling happened in the top first row then end the game! 
				-- if the filling happened in row2 or row3 we need to alert the player 
				if j == 1 then
					-- call game_over() in game.lua
					game_over()
					return
				elseif j == 2 or j == 3 then
					-- play alert SFX in audioManager.lua
					audio_playAlertSFX()
				end
			end
		end
	end
end

function board_checkRows()

	emptyCells = 0
	for row = 1, ySize do
		-- reset emptyCells counter for another row
		emptyCells = 0
		
		for col = 1, xSize do
			if boardCells[col][row].empty == true then
			   emptyCells = emptyCells + 1
			end
		end
		
		if emptyCells == 0 then
			board_eraseRow(row)
		else
			emptyCells = 0
		end
	end
	
	-- after filling the blocks inside the board now we can spawn another blocks
	board_nextSpawn()
end

function board_eraseRow(row)
	
	for col = 1, xSize do
		boardCells[col][row].texture = boardPiece
		boardCells[col][row].empty = true
	end
	
	-- Reset number of empty spaces for this line.
	linesTracer[row] = 10
	
	-- Change topReachedLineIndex
	topReachedLineIndex = topReachedLineIndex - 1
				
	for i = row-1, 1, -1 do	
		for col = 1, xSize do
			if boardCells[col][i].empty == false then
				-- first copy them down
				boardCells[col][i+1].texture = boardCells[col][i].texture
				boardCells[col][i+1].empty = false

				-- then remove them from above
				boardCells[col][i].texture = boardPiece
				boardCells[col][i].empty = true
				
				-- Adjust number of empty spaces for these lines.
				linesTracer[i+1] = linesTracer[i+1] - 1
				linesTracer[i] = linesTracer[i] + 1
			end
		end
	end
			   
	-- update player score
	updateScore( 1 );
end

function board_nextSpawn()
	
	blockId = 0
	
	if levelofDifficulty == "easy" then
		blockId = board_pickupRandomBlock()
	elseif levelofDifficulty == "medium" then
		blockId = board_pickupBadBlock()
	elseif levelofDifficulty == "hard" then
		blockId = board_pickupWorstBlock()
	end
	
	-- call block_spawn in block.lua
	block_spawn(blockId)
end


spawnCount = 0
lastSpawnId = 0

-- Easy
function board_pickupRandomBlock()
	-- generate the random number between 0 and 6, which represent the block shapes
	return love.math.random( 0, 6 )
end

-- Medium
function board_pickupBadBlock()
	worstId = 0
	if spawnCount == 0 then
		worstId = love.math.random( 4, 5 )
		spawnCount = spawnCount + 1
	elseif spawnCount == 1 or spawnCount == 2 then
		worstId = lastSpawnId
		spawnCount = spawnCount + 1
	else
		-- 1. method - Scanning the board
		worstId = board_pickUpTheWorstForMe(lastSpawnId)
	end
	
	lastSpawnId = worstId
	return worstId
end


debugTxt = "Not yet"		-- just for debugging.
minEmptyLineIndex = 15		-- will move inside the func. [after finish debugging]
minLines = {}
minLinesLastIndex = 1
-- Hard
function board_pickupWorstBlock()
	-- block id which will return to the spawn function.
	worstId = 0
	
	-- Out target is to make it impossible for the player to clear one single line!!! (How evil)
	-- 1. Find line that has the minimum number of empty spaces. Note: I'll start form the bottom.
	minEmptyLineIndex = findMinLine()
	
	-- Check if there are more than 4 empty spaces.
	if linesTracer[minEmptyLineIndex] > 4 then
		-- Pick up a random block.
		worstId = board_pickupRandomBlock()
	else
		isDone = false
		while isDone == false do
			-- check if all the empty blocks are contiguous and their tops are free as well.
			if checkContiguous(minEmptyLineIndex) == linesTracer[minEmptyLineIndex] then
				debugTxt = linesTracer[minEmptyLineIndex] .. " contiguous"
				worstId = pickUpWorstBlockBlockForContiguous(linesTracer[minEmptyLineIndex])
				-- get out of the loop, don't search any more.
				isDone = true
			else
				debugTxt = "Search for another line..."
				minEmptyLineIndex = findMinLine()
				if minEmptyLineIndex == -1 then
					-- get out of the loop, don't search any more.
					isDone = true
					-- Pick up a random block.
					worstId = board_pickupRandomBlock()
				end
			end
		end
	end
	
	-- Clear minLines table. 
	for k in pairs (minLines) do
		minLines[k] = nil
	end
	minLinesLastIndex = 1
	
	-- return id for the next generated block.
	return worstId
end

function findMinLine()
	index = 15
	for i = ySize, 1, -1 do
		-- check to make sure this line (i) is not a previous minLine minLines[m].
		for m = 1, minLinesLastIndex do
			if minLines[m] ~= i then
				if linesTracer[i] <= linesTracer[index] then
					index = i
				end
			end
		end
	end
	
	-- Save minLine index. so we can skip it later on if we want to find another minLine if this line failed to be the min.
	-- has minimum number of empty spaces however they are blocked from the top side.
	if minLinesLastIndex <= 15 then
		minLines[minLinesLastIndex] = index
		minLinesLastIndex = minLinesLastIndex + 1
	else
		debugTxt = "minLines is Filled!!"
		return -1
	end
	
	-- return index of the minLine.
	return index
end

function pickUpWorstBlockBlockForContiguous(contiguousNum)
	worstId = 0
	
	if contiguousNum == 1 then
		-- pick up Square block.
		worstId = 0
	elseif contiguousNum == 2 then
		-- pick up Tree or Dash block.
		if love.math.random( 0, 1 ) == 0 then
			worstId = 6
		else
			worstId = 3
		end
	elseif contiguousNum == 3 then
		-- pick up left or right snake block.
		worstId = love.math.random( 4, 5 )
	elseif contiguousNum == 4 then
		-- pick up any block except the dash.
		worstId = love.math.random( 0, 6 )
		maxTry = 5
		while worstId == 3 and maxTry > 0 do
			worstId = love.math.random( 0, 6 )
			maxTry = maxTry - 1
		end
		if worstId == 3 then
			worstId = 0
		end
	end
	
	-- return picked block id.
	return worstId
end

-- This function will return the number of contiguous empty and their tops are empty as well.
-- If all the empty spaces are contiguous and free form the top, then 
-- the return value will be exactly equal linesTracer[minEmptyLineIndex]
function checkContiguous(row)
	-- variable holds the value of the contiguous empty block.
	contiguous = 0
	
	-- Check the rest of elements.
	for i = 1, xSize do
		-- Check if this block is an empty block.
		if boardCells[i][row].empty == true then
		
			-- There is already an empty block(s).
			if contiguous > 0 then
				-- To consider this block contiguous with previous one the previous should be empty as well.
				if boardCells[i-1][row].empty == true then
					-- Check if there are filled block on the top of this block.
					if checkBlockOnTopOfMe(i, row) == false then
						contiguous = contiguous + 1
					end
				end
				
			-- this is the first empty block.
			else
				-- Check if there are filled block on the top of this block.
				if checkBlockOnTopOfMe(i, row) == false then
					contiguous = contiguous + 1
				end
			end
			
		end
	end
	
	debugTxt = " " .. contiguous
	
	-- return number of contiguous empty block in this line.
	return contiguous
end

function checkBlockOnTopOfMe(xIndex, yIndex)
	for i = yIndex - 1, topReachedLineIndex, -1 do
		-- Check if there is a filled block on top of me.
		if boardCells[xIndex][i].empty == false then
			-- Yes there is a filled block.
			return true
		end
	end
	-- return false if there is no filled block on the top of the target block.
	return false
end




function board_draw()
	-- draw the board cells
	for i = 1, xSize do
		for j = 1, ySize do
			-- we don't want to draw the default texture
			if boardCells[i][j].empty == false then 
				love.graphics.draw(boardCells[i][j].texture, boardCells[i][j].xPos, boardCells[i][j].yPos)
			end
		end
	end
	
	-- draw the falling block in block.lua
	block_draw()
	
	
	
	--- Just for debugging ---
	-- if minEmptyLineIndex ~= -1 then
		-- love.graphics.print( "Line : " .. minEmptyLineIndex .. " Empty : " .. linesTracer[minEmptyLineIndex] , 100,100)
	-- else
		-- love.graphics.print( "minEmptyLineIndex : -1" , 100,100)
	-- end
	-- love.graphics.print( "contiguous : " .. debugTxt , 100,200)
	
	
	-- for j = 1, minLinesLastIndex do
		-- if minLines[j] ~= nil then
			-- love.graphics.print( "minLines-" .. j .. " = " .. minLines[j] , 400,200 + j * 2)
		-- end
	-- end
	
end

















