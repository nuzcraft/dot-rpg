extends Actor
class_name Hero

signal enemy_contact

func _on_Area2D_area_entered(area):
	var other = area.get_parent()
	if other.is_in_group("enemy"):
		print(ACTOR_NAME, " makes contact with enemy ", other.ACTOR_NAME, ".")
		emit_signal("enemy_contact", self, other)
