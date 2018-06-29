extends Node

var game_manager

const FOOD = preload("res://Scenes/Food.tscn") 
const SPIKE = preload("res://Scenes/Spike.tscn") 

var foods = Array()
var food_eaten = 0
var food_round = 0
var food_round_max = 5

var spikes = Array()

func _ready():	
	game_manager = get_tree().get_root().get_node("GameManager")
	game_manager.load_game()
	$HUD.update_best(game_manager.save_data["best"])

	randomize()

	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()	
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	spawn_food()	
	spawn_spike()

func _physics_process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func get_object_from_pool(var array):
	var object = null
	
	for o in array:
		if o.visible == false:
			o.show()
			return o
			
	return null	
		
func spawn_food():	
	var food = get_object_from_pool(foods)
			
	if food == null:
		food = FOOD.instance()
		foods.append(food) 
		add_child(food)
	
	food.new_position()

func spawn_spike():	
	var spike = get_object_from_pool(spikes)
			
	if spike == null:
		spike = SPIKE.instance()
		spikes.append(spike) 
		add_child(spike)
	
	spike.reinstate()

func game_over():
	if $Timer.time_left == 0:
		
		if food_eaten > game_manager.save_data["best"]:
			print("new highscore")
			game_manager.save_data["best"] = food_eaten
			game_manager.save_game()
			
		print("game over")
		$Timer.wait_time = 3
		$Timer.start()
		yield($Timer, "timeout")
		print("reload scene")
		get_tree().reload_current_scene()

func _on_Player_eat_food():	
	food_eaten += 1		
	$HUD.update_food(food_eaten)
	spawn_food()
	
	food_round += 1
	if food_round >= food_round_max:
		food_round = 0
		spawn_food()
		spawn_spike()
