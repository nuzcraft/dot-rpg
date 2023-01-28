extends Control

func _ready():
	SoundPlayer.play_sound(SoundPlayer.DIED)
	$"VBoxContainer/Again!".grab_focus()

func _on_Again_pressed():
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/gameplay/gameplay.tscn", params)

func _on_MainMenu_pressed():
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/menu/menu.tscn", params)
