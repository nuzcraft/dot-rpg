extends Enemy
class_name Uhorn

var attack_this_turn = true

func choose_turn():
	if attack_this_turn:
		attack_this_turn = false
		if MAGIC > ATTACK:
			return "magic"
		return "attack"
	else:
		return "wait"
