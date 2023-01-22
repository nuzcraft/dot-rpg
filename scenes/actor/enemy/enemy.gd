extends Actor
class_name Enemy

func die():
	print(ACTOR_NAME, " died.")
	queue_free()
