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

enum {
	EXPLORE
}

var game_state = EXPLORE

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
	hero.connect("enemy_contact", self, "_on_Hero_enemy_contact")

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
	
