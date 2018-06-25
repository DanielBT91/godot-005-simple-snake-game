extends Node

const FOOD = preload("res://Scenes/Food.tscn") 

var foods = Array()
var food_eaten = 0
var food_round = 0
var food_round_max = 5

func _ready():	
	randomize()

	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()	
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	spawn_food()

func _physics_process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
		
func spawn_food():	
	var food = null
	
	for f in foods:
		if f.visible == false:
			food = f
			food.show()
			break
			
	if food == null:
		food = FOOD.instance()
		foods.append(food) 
		add_child(food)
	
	var pos
	for i in 100:
		
		pos = Vector2(round(rand_range(0, 19)), round(rand_range(1, 10))) * 64
		pos += Vector2(32, 32)
		
		if pos == $Player.global_position:
			print("food on player new pos")
			continue
		
		for part in $Player.parts:
			if pos == part.global_position:
				print("food on part new pos")
				continue
		
		for f in foods:
			if pos == f.global_position:
				print("food on other food new pos")
				continue
		
		break			
		
	food.global_position = pos
	
	return true

func game_over():
	if $Timer.time_left == 0:
		print("game over")
		$Timer.wait_time = 3
		$Timer.start()
		yield($Timer, "timeout")
		print("reload scene")
		get_tree().reload_current_scene()


func _on_Player_eat_food():
	$Player.canMove = false
	food_eaten += 1		
	$HUD.update_hud(food_eaten)
	spawn_food()
	
	food_round += 1
	if food_round >= food_round_max:
		food_round = 0
		spawn_food()
	$Player.canMove = true
