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
