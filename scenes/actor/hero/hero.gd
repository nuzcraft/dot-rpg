extends Actor
class_name Hero

signal enemy_contact
signal need_to_level_up

var level_up = {
	1: 3,
	2: 5,
	3: 7,
	4: 7,
	5: 7,
	6: 7,
	7: 9,
	8: 11,
	9: 15,
}

var kills = 0

func _on_Area2D_area_entered(area):
	var other = area.get_parent()
	if other.is_in_group("enemy"):
		print(ACTOR_NAME, " makes contact with enemy ", other.ACTOR_NAME, ".")
		emit_signal("enemy_contact", self, other)

func die():
	print(ACTOR_NAME, " died.")
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/gameover/gameover.tscn", params)

func check_for_level_up():
	var temp_level = LEVEL
	if temp_level > 9:
		temp_level = 9
	if kills >= level_up[temp_level]:
		kills = 0
		emit_signal("need_to_level_up")
