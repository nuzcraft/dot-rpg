extends Node

var elapsed = 0

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
	$Sprite.rect_position = Game.size / 2
	print("Processing...")
	yield(get_tree().create_timer(2), "timeout")
	print("Done")

# `start()` is called when the graphic transition ends.
func start():
	print("gameplay.gd: start() called")

func _process(delta):
	elapsed += delta
	$Sprite.rect_position.x = Game.size.x / 2 + 10 * sin(2 * 0.4 * PI * elapsed)
	$Sprite.rect_position.y = Game.size.y / 2 + 5 * sin(2 * 0.2 *  PI * elapsed)
	
func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
