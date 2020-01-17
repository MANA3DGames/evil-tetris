-- Programmed by Mahmoud Abu Obaid
function love.conf( t )
	t.title = "Evil Tetris!"
	t.author = "Mahmoud Abu Obaid"
	
	t.screen.fullscreen = true
	t.screen.vsync = true
	t.screen.fsaa = 0
	t.screen.width = 800
	t.screen.height = 600

	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.physics = false

end