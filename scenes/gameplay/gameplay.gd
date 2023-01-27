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
var kampan_scene = preload("res://scenes/actor/enemy/kampan/kampan.tscn")
var osena_scene = preload("res://scenes/actor/enemy/osena/osena.tscn")
var azlosa_scene = preload("res://scenes/actor/enemy/azlosa/azlosa.tscn")
var uhorn_scene = preload("res://scenes/actor/enemy/uhorn/uhorn.tscn")
var vargo_scene = preload("res://scenes/actor/enemy/vargo/vargo.tscn")
var haidi_scene = preload("res://scenes/actor/enemy/haidi/haidi.tscn")
var cebrua_scene = preload("res://scenes/actor/enemy/cebrua/cebrua.tscn")
var dragon_scene = preload("res://scenes/actor/enemy/dragon/dragon.tscn")

var enemy_spawn_chances = {
	1: {nopri_scene: 1.0},
	2: {nopri_scene: 0.5,
		dhupem_scene: 0.5},
	3: {nopri_scene: 0.4,
		dhupem_scene: 0.3,
		kampan_scene: 0.3},
	4: {dhupem_scene: 0.4,
		kampan_scene: 0.3,
		osena_scene: 0.3},
	5: {kampan_scene: 0.4,
		osena_scene: 0.3,
		azlosa_scene: 0.3},
	6: {osena_scene: 0.4,
		azlosa_scene: 0.3,
		uhorn_scene: 0.3},
	7: {azlosa_scene: 0.4,
		uhorn_scene: 0.3,
		vargo_scene: 0.3},
	8: {uhorn_scene: 0.4,
		vargo_scene: 0.3,
		haidi_scene: 0.3},
	9: {vargo_scene: 0.4,
		haidi_scene: 0.3,
		cebrua_scene: 0.3},
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
	hero.connect("need_to_level_up", self, "_on_Hero_need_to_level_up")
	statsLayer.connect("leveled_up", self, "_on_StatsLayer_leveled_up")
	
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
		
func _on_Hero_need_to_level_up():
	statsLayer.need_to_level_up = true
	statsLayer.pause_game()
	
func _on_EnemySpawner_timeout():
	var num_enemies = get_tree().get_nodes_in_group("enemy").size()
	if num_enemies <= 7:
		spawn_random_enemy()
	elif num_enemies < 3:
		spawn_random_enemy()
		spawn_random_enemy()

func spawn_random_enemy():
	var num = rng.randf()
	var summed_chance = 0.0
	var hero_level = hero.LEVEL
	if hero_level > 9:
		hero_level = 9
	for enemy_scene in enemy_spawn_chances[hero_level]:
		summed_chance += enemy_spawn_chances[hero_level][enemy_scene]
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
	return obj

func _on_BattleLayer_battle_exited():
	$EnemySpawner.paused = false
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.unpause_timer()
	
func _on_Enemy_despawn_timer_timeout(enemy):
	enemy.queue_free()
	print(enemy.ACTOR_NAME, " left the area.")
	
func _on_StatsLayer_leveled_up(level):
	if level == 10:
		var dragon = spawn_enemy(dragon_scene)
		dragon.connect("dragon_defeated", self, "_on_Dragon_defeated")
		
func _on_Dragon_defeated():
	var params = {
		show_progress_bar = true
	}
	Game.change_scene("res://scenes/win/win.tscn", params)
