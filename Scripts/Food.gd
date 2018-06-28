extends Area2D

onready var tween = get_node("Tween")

func new_position():
	var pos = Vector2(round(rand_range(0, 19)), round(rand_range(1, 10))) * 64
	pos += Vector2(32, 32)
	global_position = pos

func _on_Food_area_entered(area):
	if area.is_in_group("object"):
		new_position()

func _ready():
	start_tween()
	
func start_tween():
	var sp = 1
	tween.interpolate_property($Sprite, "scale", Vector2(2, 2), Vector2(1.75, 1.75), sp, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property($Sprite, "scale", Vector2(1.75, 1.75), Vector2(2.25, 2.25), sp, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property($Sprite, "scale", Vector2(2.25, 2.25), Vector2(2, 2), sp, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	start_tween()
	
func _on_Tween_tween_completed(object, key):
	pass
