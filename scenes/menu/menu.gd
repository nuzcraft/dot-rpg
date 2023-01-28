extends Control


func _ready():
	$MainContainer/RightContainer/GameVersion.text = ProjectSettings.get_setting("application/config/version")
	# needed for gamepads to work
	$MainContainer/LeftContainer/PlayButton.grab_focus()
	if OS.has_feature('HTML5'):
		$MainContainer/LeftContainer/ExitButton.queue_free()
	VisualServer.set_default_clear_color(Color(0.93, 0.96, 0.84, 1.0))


func _on_PlayButton_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/gameplay/gameplay.tscn", params)
	SoundPlayer.play_music(SoundPlayer.MUSIC)


func _on_ExitButton_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	# gently shutdown the game
	var transitions = get_node_or_null("/root/Transitions")
	if transitions:
		transitions.fade_in({
			'show_progress_bar': false
		})
		yield(transitions.anim, "animation_finished")
		yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()
