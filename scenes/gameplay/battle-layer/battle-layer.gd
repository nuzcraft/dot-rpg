extends CanvasLayer

onready var battle = $Battle
onready var enemyNameLabel = $Battle/VBoxContainer/EnemyContainer/Name
onready var enemyHPLabel = $Battle/VBoxContainer/EnemyContainer/HP
onready var heroNameLabel = $Battle/VBoxContainer/HeroContainer/Name
onready var heroHPLabel = $Battle/VBoxContainer/HeroContainer/HP
onready var attack = $Battle/VBoxContainer/ActionContainer/VBoxContainer/Attack

var hero
var enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	if enemy:
		set_enemy_hp()
	if hero:
		set_hero_hp()
	
func start_battle(hero_param, enemy_param):
	hero = hero_param
	enemy = enemy_param
	
	set_enemy_name()
	set_enemy_hp()
	set_hero_name()
	set_hero_hp()
	
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
	var amount = enemy.calc_damage(hero.ATTACK)
	if amount < 0:
		amount = 0
	print(hero.ACTOR_NAME, " attacks ", enemy.ACTOR_NAME, " for ", amount, " damage.")
	enemy.take_damage(amount)

func _on_Magic_pressed():
	var amount = enemy.calc_magic_damage(hero.MAGIC)
	if amount < 0:
		amount = 0
	print(hero.ACTOR_NAME, " casts magic at ", enemy.ACTOR_NAME, " for ", amount, " damage.")
	enemy.take_damage(amount)
	
func _on_Defend_pressed():
	print(hero.ACTOR_NAME, " steels themself for a strike.")
	hero.defend()

func _on_Run_pressed():
	print(hero.ACTOR_NAME, " flees!")
	battle.hide()
