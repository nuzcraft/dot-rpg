extends Control

func _on_Again_pressed():
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/gameplay/gameplay.tscn", params)

func _on_MainMenu_pressed():
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/menu/menu.tscn", params)
