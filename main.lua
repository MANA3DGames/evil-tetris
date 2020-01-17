-- In the main we only need to load the game which is like the heart of our game
require "game"

function love.load()
	game_load()
end

function love.update(dt)
	game_update(dt)
end

function love.draw()
	game_draw()
end