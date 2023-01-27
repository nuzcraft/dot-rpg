extends Enemy
class_name Dragon

signal dragon_defeated
#attack attack defend magic defend

var turn = 1
var turn_order = {
	1: "attack",
	2: "attack",
	3: "defend",
	4: "magic",
	5: "defend"
}

func choose_turn():
	var chosen_turn = turn_order[turn]
	if turn < 5:
		turn += 1
	else:
		turn = 1
	return chosen_turn

func die():
	print(ACTOR_NAME, " died.")
	emit_signal("dragon_defeated")
	
