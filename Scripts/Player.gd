extends Area2D

onready var game_manager = get_node("/root/GameManager")

const PART = preload("res://Scenes/Part.tscn")

var movementSpeed = 0;
var direction = Vector2()
var old_direction = Vector2()
var targetPosition = Vector2()
var parts = Array()
var hasMoved = false
var old_rotation = 0

signal eat_food

func _ready():
	targetPosition = position
	add_part()
	add_part()
	add_part()

func _on_TimerFlash_timeout():
	visible = !visible

func add_part():
	var part = PART.instance()
	if(parts.size() > 0):
		part.global_position = parts[parts.size() - 1].global_position
	else:
		part.global_position = global_position
	get_parent().call_deferred("add_child", part)
	parts.append(part)
	part.visible = false

func _process(delta):
	if game_manager.state == game_manager.GAMESTATE.GAME_OVER:
		return	
	
	if  Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
		$Sprite.rotation_degrees = 0		
		
	if  Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
		$Sprite.rotation_degrees = 180
		
	if  Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
		$Sprite.rotation_degrees = -90
		
	if  Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		$Sprite.rotation_degrees = 90
		
	if !hasMoved and direction != Vector2(0,0):
		hasMoved = true
		game_manager.state = game_manager.GAMESTATE.PLAYING
	
	if hasMoved:		
		if old_direction == direction * -1:
			direction = old_direction
			$Sprite.rotation_degrees = old_rotation
		
		movementSpeed += delta
		if movementSpeed > .25 and position == targetPosition:
			manage_parts()
			movementSpeed = 0		
			position += direction * 64
			old_direction = direction
			targetPosition = targetPosition + (direction * 64)
		
		check_out_of_screen()

func check_out_of_screen():
	
	if game_manager.state != game_manager.GAMESTATE.PLAYING:
		return
		
	var kill = false	
	if get_viewport().get_visible_rect().size.x < global_position.x or 0 > global_position.x:
		kill = true;
	if get_viewport().get_visible_rect().size.y < global_position.y or 0 > global_position.y:
		kill = true;
		
	if kill:
		game_over()
		
func manage_parts():
	var pos = null
	for i in parts.size():	
		parts[i].visible = true	
		if pos == null:
			pos = parts[i].global_position
			parts[i].global_position = global_position
		else:
			var old_pos = parts[i].global_position
			parts[i].global_position = pos
			pos = old_pos
	
	for i in parts.size():
		var cur = parts.size() - i - 1
		if cur == 0:
			continue			
		parts[cur].get_node("Sprite").rotation_degrees = parts[cur - 1].get_node("Sprite").rotation_degrees
		parts[cur].get_node("Sprite").set_texture(parts[cur - 1].get_node("Sprite").get_texture())
	
	if old_rotation != $Sprite.rotation_degrees:
		if old_rotation == 90 and $Sprite.rotation_degrees == 90:
			parts[0].get_node("Sprite").rotation_degrees = 90
		if old_rotation == 0 and $Sprite.rotation_degrees == -90:
			parts[0].get_node("Sprite").rotation_degrees = 90
		if old_rotation == -90 and $Sprite.rotation_degrees == 180:
			parts[0].get_node("Sprite").rotation_degrees = 0
		if old_rotation == 180 and $Sprite.rotation_degrees == 90:
			parts[0].get_node("Sprite").rotation_degrees = -90
		if old_rotation == 90 and $Sprite.rotation_degrees == 0:
			parts[0].get_node("Sprite").rotation_degrees = 180
		if old_rotation == 0 and $Sprite.rotation_degrees == 90:
			parts[0].get_node("Sprite").rotation_degrees = 0
		if old_rotation == 90 and $Sprite.rotation_degrees == 180:
			parts[0].get_node("Sprite").rotation_degrees = 90
		if old_rotation == -90 and $Sprite.rotation_degrees == 0:
			parts[0].get_node("Sprite").rotation_degrees = -90
		if old_rotation == 180 and $Sprite.rotation_degrees == -90:
			parts[0].get_node("Sprite").rotation_degrees = 180
			
		old_rotation = $Sprite.rotation_degrees
		parts[0].get_node("Sprite").set_texture(parts[0].PART_CORNER)
	else:
		parts[0].get_node("Sprite").set_texture(parts[0].PART_SPRITE)
		parts[0].get_node("Sprite").rotation_degrees = $Sprite.rotation_degrees

	parts[parts.size() - 1].get_node("Sprite").set_texture(parts[0].PART_TAIL)

func game_over():
	if game_manager.state != game_manager.GAMESTATE.GAME_OVER:
		get_parent().game_over()
		$TimerFlash.start()
		for part in parts:
			part.get_node("TimerFlash").start()

func _on_Player_area_entered(area):	
	if game_manager.state == game_manager.GAMESTATE.PLAYING:	
		if area.is_in_group("food"):
			area.global_position = Vector2(-100, -100)
			area.hide()
			add_part()
			emit_signal("eat_food")						
		elif area.is_in_group("part"):
			game_over()			
		elif area.is_in_group("spike"):
			if area.danger:
				game_over()
		