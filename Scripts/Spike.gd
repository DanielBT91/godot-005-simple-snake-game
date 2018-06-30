extends Area2D

onready var tween = $Sprite/Tween
onready var game_manager = get_node("/root/GameManager")

var counter = 0
var counterMax = 5
var danger = false

func reinstate():
	tween.stop_all()
	new_position()
	start_tween()

func new_position():
	var pos = Vector2(round(rand_range(0, 19)), round(rand_range(1, 10))) * 64
	pos += Vector2(32, 32)
	global_position = pos
	
func _process(delta):	
	if game_manager.state == game_manager.GAMESTATE.GAME_OVER:
		tween.stop_all()
		return
	
	counter += delta
	if counter > counterMax:
		counter = 0
		tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		tween.start()
		yield(tween, "tween_completed")
		reinstate()

func start_tween():
	tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.start()
	danger = false

func _on_Tween_tween_completed(object, key):
	tween.interpolate_property($Sprite, "rotation_degrees", $Sprite.rotation_degrees, $Sprite.rotation_degrees + 360, 5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.start()
	danger = true
	
func _on_Spike_area_entered(area):
	if !area.is_in_group("player"):	
		reinstate()
