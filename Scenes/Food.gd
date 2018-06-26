extends Area2D

func new_position():
	var pos = Vector2(round(rand_range(0, 19)), round(rand_range(1, 10))) * 64
	pos += Vector2(32, 32)
	global_position = pos

func _on_Food_area_entered(area):
	if area.is_in_group("food"):
		new_position()			
	elif area.is_in_group("part"):
		new_position()
	elif area.is_in_group("player"):
		new_position()
