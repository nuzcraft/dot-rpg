extends Enemy
class_name Vargo

var attack_this_turn = true

func choose_turn():
	if attack_this_turn:
		attack_this_turn = false
		if MAGIC > ATTACK:
			return "magic"
		return "attack"
	else:
		attack_this_turn = true
		return "defend"
