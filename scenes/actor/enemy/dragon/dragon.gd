extends Enemy
class_name Dragon

signal dragon_defeated
#attack attack defend magic defend

func die():
	print(ACTOR_NAME, " died.")
	emit_signal("dragon_defeated")
	
