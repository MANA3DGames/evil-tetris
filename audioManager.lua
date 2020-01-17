
function audio_load()
	-- load the background music
	bgm = love.audio.newSource("Audio/bgm.mp3")
	bgm:setVolume(0.6)
	bgm:setPitch(0.5)
	-- we want the background music to be looped 
	bgm:setLooping(true)
	
	-- load all the audio source files
	startSFX = love.audio.newSource("Audio/start_SFX.mp3", "static")
	startSFX:setVolume(1.0)
	clickSFX = love.audio.newSource("Audio/click_SFX.mp3", "static")
	clickSFX:setVolume(1.0)
	rotateSFX = love.audio.newSource("Audio/rotate_SFX.mp3", "static")
	rotateSFX:setVolume(1.0)
	errorSFX = love.audio.newSource("Audio/error_SFX.mp3", "static")
	errorSFX:setVolume(1.0)
	alertSFX = love.audio.newSource("Audio/alert_SFX.mp3", "static")
	alertSFX:setVolume(1.0)
	gameoverSFX = love.audio.newSource("Audio/gameover_SFX.mp3", "static")
	gameoverSFX:setVolume(1.0)
	rowSFX = love.audio.newSource("Audio/row_SFX.mp3", "static")
	rowSFX:setVolume(1.0)
	cheatSFX = love.audio.newSource("Audio/cheat_SFX.mp3", "static")
	cheatSFX:setVolume(1.0)
	
	-- play the Background music from the beginning
	audio_playBGM()
end


function audio_playBGM()
	bgm:play()
end

function audio_playStartSFX()
	startSFX:play()
end

function audio_playClickSFX()
	clickSFX:play()
end

function audio_playRotateSFX()
	if errorSFX:isPlaying() == true then
		errorSFX:stop()
	end
	if rotateSFX:isPlaying() == true then
		rotateSFX:rewind()
	else
		rotateSFX:play()
	end
end

function audio_playErrorSFX()
	if rotateSFX:isPlaying() == true then
		rotateSFX:stop()
	end
	if errorSFX:isPlaying() == true then
		errorSFX:rewind()
	else
		errorSFX:play()
	end
end

function audio_playAlertSFX()
	alertSFX:play()
end

function audio_playGameOverSFX()
	if alertSFX:isPlaying() == true then
		alertSFX:stop()
	end
	
	gameoverSFX:play()
end

function audio_playRowSFX()
	rowSFX:play()
end

function audio_playCheatSFX()
	cheatSFX:play()
end




















