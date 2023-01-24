extends Actor
class_name Enemy

signal despawn_timer_timeout

func die():
	print(ACTOR_NAME, " died.")
	queue_free()

func _on_Despawn_timeout():
	emit_signal("despawn_timer_timeout", self)
