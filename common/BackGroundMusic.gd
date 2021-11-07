extends Node2D

var is_playing : bool = false

func start_music():
	if not is_playing:
		is_playing = true
		$Music.play()

func stop_music():
	if is_playing:
		is_playing = false
		$Music.stop
		
func pause_music():
	if is_playing:
		$Music.playing = false
		is_playing = false

func resume_music():
	if !is_playing:
		$Music.playing = true
		is_playing = true
