-- current this only responsible for creating button for the difficultly screen
_buttons = {}	-- table (array) of buttons

function button_create(id, x, y, str, font)
	-- this will create a button and add it to _buttons array
	table.insert(_buttons, {id = id, x = x, y = y, text = str, font = font, mouseOver = false})
end 

function button_click(xPos,yPos)
	-- go through the _buttons to check the mouse was click on one of the buttons position
	for	i,v in ipairs(_buttons) do
		if xPos > v.x and
		xPos < v.x + v.font:getWidth(v.text) and
		yPos > v.y and 
		yPos < v.y + v.font:getHeight() then
			if v.id == "easy" or v.id == "medium" or v.id == "hard" then
				-- after selecting the difficultly of the game now we can start a new game
				game_start(v.id)
			end
		end
	end
end

function button_check(xPos,yPos)
	-- this will check if the mouse is over one of the buttons
	-- to change its colour
	for	i,v in ipairs(_buttons) do
		if xPos > v.x and
		xPos < v.x + v.font:getWidth(v.text) and
		yPos > v.y and 
		yPos < v.y + v.font:getHeight() then
			v.mouseOver = true
		else
			v.mouseOver = false
		end
	end
end

function button_draw()
	-- draw all the button inside _buttons table 
	for	i,v in ipairs(_buttons) do
		-- change its colour as long as the mouse is over this button
		if v.mouseOver == false then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(0,255,255)
		end
		
		-- print the text of the button
		love.graphics.setFont(v.font)
		love.graphics.printf(v.text,v.x,v.y,10)
	end
end





