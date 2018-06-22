extends Area2D

const PART = preload("res://Scenes/Part.tscn")

var movementSpeed = 0;
var direction = Vector2()
var targetPosition = Vector2()
var parts = Array()
var hasMoved = false

func _ready():
	targetPosition = position
	add_part()
	add_part()
	add_part()

func add_part():
	var part = PART.instance()
	part.global_position = global_position
	get_parent().call_deferred("add_child", part)
	parts.append(part)

func _process(delta):
	
	if  Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
		
	if  Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
		
	if  Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
		
	if  Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		
	if !hasMoved and direction == Vector2(0,0):
		hasMoved = true
	
	movementSpeed += delta
	if movementSpeed > .25 and position == targetPosition:
		
		var pos = null
		for part in parts:
			if pos == null:
				pos = part.global_position
				part.global_position = global_position
			else:
				var old_pos = part.global_position
				part.global_position = pos
				pos = old_pos
				
		movementSpeed = 0	
		position += direction * 64
		targetPosition = targetPosition + (direction * 64)
			

func _on_Player_area_entered(area):
	if area.is_in_group("food"):
		area.queue_free()
		add_part()
		get_parent().spawn_food()
	elif hasMoved and area.is_in_group("part"):
		print(area.name)
		
		
