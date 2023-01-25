extends Node

onready var camera_pos = $Camera2D.global_position
onready var camera_bounds = {
	"top": camera_pos.y - Game.size.y / 2,
	"bottom": camera_pos.y + Game.size.y / 2 - 1,
	"left": camera_pos.x - Game.size.x / 2,
	"right": camera_pos.x + Game.size.x / 2 - 1,
}

var elapsed = 0
onready var hero = $Hero
onready var battleLayer = $BattleLayer
onready var statsLayer = $StatsLayer

enum {
	EXPLORE
}

var game_state = EXPLORE

var nopri_scene = preload("res://scenes/actor/enemy/nopri/nopri.tscn")
var dhupem_scene = preload("res://scenes/actor/enemy/dhupem/dhupem.tscn")

var enemy_spawn_chances = {
	nopri_scene: .5,
	dhupem_scene: .5
}

var rng = RandomNumberGenerator.new()

# `pre_start()` is called when a scene is loaded.
# Use this function to receive params from `Game.change_scene(params)`.
func pre_start(params):
	var cur_scene: Node = get_tree().current_scene
	print("Current scene is: ", cur_scene.name, " (", cur_scene.filename, ")")
	print("gameplay.gd: pre_start() called with params = ")
	if params:
		for key in params:
			var val = params[key]
			printt("", key, val)
	print("Processing...")
	yield(get_tree().create_timer(2), "timeout")
	print("Done")

# `start()` is called when the graphic transition ends.
func start():
	print("gameplay.gd: start() called")
	rng.randomize()
	statsLayer.set_hero(hero)
	hero.connect("enemy_contact", self, "_on_Hero_enemy_contact")
	
	spawn_random_enemy()
	spawn_random_enemy()

func _process(delta):
	elapsed += delta
	clamp_actor_on_screen(hero)
	
func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match game_state:
		EXPLORE: explore_state(input, delta)
	
func clamp_actor_on_screen(actor):
	actor.global_position.x = clamp(actor.global_position.x, camera_bounds["left"], camera_bounds["right"])
	if actor.global_position.x <= camera_bounds["left"] or actor.global_position.x >= camera_bounds["right"]:
		actor.velocity.x = 0
		
	actor.global_position.y = clamp(actor.global_position.y, camera_bounds["top"], camera_bounds["bottom"])
	if actor.global_position.y <= camera_bounds["top"] or actor.global_position.y >= camera_bounds["bottom"]:
		actor.velocity.y = 0
		
func explore_state(input, delta):
	hero.apply_acceleration(input, delta)
	hero.apply_friction(input, delta)
	
func _on_Hero_enemy_contact(hero_param, enemy):
	battleLayer.start_battle(hero_param, enemy)
	$EnemySpawner.paused = true
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.pause_timer()
	
func _on_EnemySpawner_timeout():
	var num_enemies = get_tree().get_nodes_in_group("enemy").size()
	if num_enemies <= 5:
		spawn_random_enemy()

func spawn_random_enemy():
	var num = rng.randf()
	var summed_chance = 0.0
	for enemy_scene in enemy_spawn_chances:
		summed_chance += enemy_spawn_chances[enemy_scene]
		if summed_chance >= num:
			spawn_enemy(enemy_scene)
			break
			
func spawn_enemy(scene):
	var x = rng.randf_range(camera_bounds["left"], camera_bounds["right"])
	var y = rng.randf_range(camera_bounds["top"], camera_bounds["bottom"])
	var obj = scene.instance()
	obj.position = Vector2(x, y)
	add_child(obj)
	obj.connect("despawn_timer_timeout", self, "_on_Enemy_despawn_timer_timeout")
	print(obj.ACTOR_NAME, " spawned in.")

func _on_BattleLayer_battle_exited():
	$EnemySpawner.paused = false
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.unpause_timer()
	
func _on_Enemy_despawn_timer_timeout(enemy):
	enemy.queue_free()
	print(enemy.ACTOR_NAME, " left the area.")

