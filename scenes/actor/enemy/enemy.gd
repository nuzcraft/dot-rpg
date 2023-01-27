extends Actor
class_name Enemy

signal despawn_timer_timeout

func die():
	dead = true
	print(ACTOR_NAME, " died.")
	queue_free()

func _on_Despawn_timeout():
	emit_signal("despawn_timer_timeout", self)

func pause_timer():
	$Despawn.paused = true
	
func unpause_timer():
	$Despawn.paused = false
