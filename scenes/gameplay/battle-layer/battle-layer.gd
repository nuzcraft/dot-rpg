extends CanvasLayer

signal battle_exited
signal shake

onready var battle = $Battle
onready var enemyNameLabel = $Battle/VBoxContainer/EnemyContainer/Name
onready var enemyHPLabel = $Battle/VBoxContainer/EnemyContainer/HP
onready var heroNameLabel = $Battle/VBoxContainer/HeroContainer/Name
onready var heroHPLabel = $Battle/VBoxContainer/HeroContainer/HP
onready var attack = $Battle/VBoxContainer/ActionContainer/VBoxContainer/Attack

onready var heroDamageLabel = $Battle/HeroDamageLabel
onready var enemyDamageLabel = $Battle/EnemyDamageLabel
onready var enemyStatusLabel = $Battle/EnemyStatusLabel
onready var heroDamageAnimationPlayer = $HeroDamageAnimationPlayer
onready var enemyDamageAnimationPlayer = $EnemyDamageAnimationPlayer
onready var enemyStatusAnimationPlayer = $EnemyStatusAnimationPlayer

var hero
var enemy

var in_battle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	if is_instance_valid(enemy):
		set_enemy_hp()
	else:
		if in_battle:
			in_battle = false
			battle.hide()
			emit_signal("battle_exited")
			hero.kills += 1
			hero.check_for_level_up()
	if hero:
		set_hero_hp()
	
func start_battle(hero_param, enemy_param):
	hero = hero_param
	enemy = enemy_param
	
	set_enemy_name()
	set_enemy_hp()
	set_hero_name()
	set_hero_hp()
	
	in_battle = true
	
	attack.grab_focus()
	
	battle.show()
	
func set_enemy_name():
	enemyNameLabel.text = enemy.ACTOR_NAME
	
func set_enemy_hp():
	enemyHPLabel.text = str(enemy.HP) + "/" + str(enemy.MAX_HP)
	
func set_hero_name():
	heroNameLabel.text = hero.ACTOR_NAME
	
func set_hero_hp():
	heroHPLabel.text = str(hero.HP) + "/" + str(hero.MAX_HP)

func _on_Attack_pressed():
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	var amount = enemy.calc_damage(hero.ATTACK)
	print(hero.ACTOR_NAME, " attacks ", enemy.ACTOR_NAME, " for ", amount, " damage.")
	enemyDamageLabel.text = "ATK\n-" + str(amount)
	enemyDamageAnimationPlayer.stop(true)
	enemyDamageAnimationPlayer.play("enemy_damage")
	enemy.take_damage(amount)
	emit_signal("shake", 0.5)
	
	enemy_turn()

func _on_Magic_pressed():
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	var amount = enemy.calc_magic_damage(hero.MAGIC)
	print(hero.ACTOR_NAME, " casts magic at ", enemy.ACTOR_NAME, " for ", amount, " damage.")
	enemyDamageLabel.text = "MAG\n-" + str(amount)
	enemyDamageAnimationPlayer.stop(true)
	enemyDamageAnimationPlayer.play("enemy_damage")
	enemy.take_damage(amount)
	enemy_turn()
	
func _on_Defend_pressed():
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	print(hero.ACTOR_NAME, " steels themself for a strike.")
	hero.defend()
	enemy_turn()

func _on_Run_pressed():
	SoundPlayer.play_sound(SoundPlayer.CLICK)
	print(hero.ACTOR_NAME, " flees!")
	battle.hide()
	emit_signal("battle_exited")
	
func enemy_turn():
	if not enemy.dead:
		var turn = enemy.choose_turn()
		var amount = 0
		match turn:
			"attack":
				amount = hero.calc_damage(enemy.ATTACK)
				print(enemy.ACTOR_NAME, " attacks ", hero.ACTOR_NAME, " for ", amount, " damage.")
				heroDamageLabel.text = "ATK\n-" + str(amount)
				heroDamageAnimationPlayer.stop(true)
				heroDamageAnimationPlayer.play("hero_damage")
			"magic":
				amount = hero.calc_magic_damage(enemy.MAGIC)
				print(enemy.ACTOR_NAME, " casts magic at ", hero.ACTOR_NAME, " for ", amount, " damage.")
				heroDamageLabel.text = "MAG\n-" + str(amount)
				heroDamageAnimationPlayer.stop(true)
				heroDamageAnimationPlayer.play("hero_damage")
			"wait":
				print(enemy.ACTOR_NAME, " stops to take a deep breath.")
				enemyStatusLabel.text = "WAIT"
				enemyStatusAnimationPlayer.stop(true)
				enemyStatusAnimationPlayer.play("enemy_status")
			"defend":
				enemy.defend()
				print(enemy.ACTOR_NAME, " steels themself for a strike.")
				enemyStatusLabel.text = "DEF"
				enemyStatusAnimationPlayer.stop(true)
				enemyStatusAnimationPlayer.play("enemy_status")
		hero.take_damage(amount)
	
