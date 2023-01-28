extends CanvasLayer

signal leveled_up

onready var stats := $Stats
onready var attackUp := $Stats/VBoxContainer/LevelUpContainer/AttackUp
onready var levelUpContainer := $Stats/VBoxContainer/LevelUpContainer
onready var killContainer := $Stats/VBoxContainer/KillContainer
onready var exitButton := $Stats/VBoxContainer/HBoxContainer/Exit

onready var hero_name := $Stats/VBoxContainer/HBoxContainer/Name
onready var hp := $Stats/VBoxContainer/HBoxContainer/HP
onready var level := $Stats/VBoxContainer/HBoxContainer2/VBoxContainer/Level
onready var magic := $Stats/VBoxContainer/HBoxContainer2/VBoxContainer/Magic
onready var attack := $Stats/VBoxContainer/HBoxContainer2/VBoxContainer2/Attack
onready var defense := $Stats/VBoxContainer/HBoxContainer2/VBoxContainer2/Defense
onready var kill := $Stats/VBoxContainer/KillContainer/Kills

var need_to_level_up = false
var hero
var on_stats = false

func _ready():
	if OS.has_touchscreen_ui_hint():
#		label.visible = false
		pass
	else:
		# to hide the pause_button on desktop: un-comment the next line
		# pause_button.hide()
		pass

# when the node is removed from the tree (mostly because of a scene change)
func _exit_tree() -> void:
	# disable pause
#	get_tree().paused = false
	pass

func _unhandled_input(event):
	if event.is_action_pressed("stats"):
#		if get_tree().paused:
		if on_stats:
			resume()
		else:
			pause_game()
		get_tree().set_input_as_handled()
	if on_stats:
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_accept"):
			resume()
			get_tree().set_input_as_handled()

func resume():
	if not need_to_level_up:
#		get_tree().paused = false
		on_stats = false
		stats.hide()

func pause_game():
#	get_tree().paused = true
	on_stats = true
	set_labels()
	stats.show()
	if need_to_level_up:
		levelUpContainer.show()
		killContainer.hide()
		exitButton.hide()
		attackUp.grab_focus()
		
func set_hero(actor):
	hero = actor
		
func set_labels():
	hero_name.text = hero.ACTOR_NAME
	hp.text = "HP" + str(hero.HP) + "/" + str(hero.MAX_HP)
	if hero.LEVEL < 10:
		level.text = "LVL0" + str(hero.LEVEL)
	else:
		level.text = "LVL" + str(hero.LEVEL)
	if hero.MAGIC < 10:
		magic.text = "MAG0" + str(hero.MAGIC)
	else:
		magic.text = "MAG" + str(hero.MAGIC)
	if hero.ATTACK < 10:
		attack.text = "ATK0" + str(hero.ATTACK)
	else:
		attack.text = "ATK" + str(hero.ATTACK)
	if hero.DEFENSE < 10:
		defense.text = "DEF0" + str(hero.DEFENSE)
	else:
		defense.text = "DEF" + str(hero.DEFENSE)
	kill.text = "KILLS LEFT:" + str(hero.level_up[hero.LEVEL] - hero.kills)

func _on_AttackUp_pressed():
	SoundPlayer.play_sound(SoundPlayer.LEVEL_UP)
	hero.attack_up()
	need_to_level_up = false
	levelUpContainer.hide()
	killContainer.show()
	exitButton.show()
	set_labels()
	emit_signal("leveled_up", hero.LEVEL)
	
func _on_DefenseUp_pressed():
	SoundPlayer.play_sound(SoundPlayer.LEVEL_UP)
	hero.defense_up()
	need_to_level_up = false
	levelUpContainer.hide()
	killContainer.show()
	exitButton.show()
	set_labels()
	emit_signal("leveled_up", hero.LEVEL)

func _on_MagicUp_pressed():
	SoundPlayer.play_sound(SoundPlayer.LEVEL_UP)
	hero.magic_up()
	need_to_level_up = false
	levelUpContainer.hide()
	killContainer.show()
	exitButton.show()
	set_labels()
	emit_signal("leveled_up", hero.LEVEL)

func _on_Exit_pressed():
	resume()
