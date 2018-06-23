extends Node

const FOOD = preload("res://Scenes/Food.tscn") 

func _ready():	
#	randomize()

	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()	
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	spawn_food()

func _physics_process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
		
func spawn_food():
	var food = FOOD.instance()
	
	var pos
	for i in 20:
		
		pos = Vector2(round(rand_range(0, 20)), round(rand_range(1, 10))) * 64
		pos += Vector2(32, 32)
		
		if pos == $Player.global_position:
			print("food on player new pos")
			continue
		
		for part in $Player.parts:
			if pos == part.global_position:
				print("food on part new pos")
				continue
		break			
		
	food.global_position = pos
	add_child(food)

func game_over():
	if $Timer.time_left == 0:
		print("game over")
		$Timer.wait_time = 3
		$Timer.start()
		yield($Timer, "timeout")
		print("reload scene")
		get_tree().reload_current_scene()
