local _timer = 0.0		-- timer to decide the amount of time the text will appear on the screen
local _showTxt = true	-- This will be use to show and hide text

function title_load()
	-- Load the background image for the screen title
	titleImage = love.graphics.newImage("Images/TitleScreen.jpg")
	
	-- load and create different size of font
	fontSmall = love.graphics.newFont("Fonts/DEADJIM.TTF", 30)
	fontMedium = love.graphics.newFont("Fonts/DEADJIM.TTF", 40)
	fontLarge = love.graphics.newFont("Fonts/DEADJIM.TTF", 50)
	fontTitle = love.graphics.newFont("Fonts/DEADJIM.TTF", 60)
	
	-- set the font size to medium for the "Press Any Key..."
	love.graphics.setFont(fontMedium)
	
	-- init the _timer -> set it to the current time
	_timer = love.timer.getTime()
end

function title_update(dt)
	-- create a kinda flash effect for the text
	if love.timer.getTime() > _timer + 0.5 then
		_timer = love.timer.getTime()
		--_showTxt = !_showTxt
		if _showTxt == true then
			_showTxt = false
		else
			_showTxt = true
		end
	end
end

function title_draw()
	-- draw the background image for the Title screen
	love.graphics.draw(titleImage, 0, 0)
	
	-- print out the text
	if _showTxt == true then
		love.graphics.print("Press Any Key to Play!", 200, 500)
	end
end