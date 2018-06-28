extends Area2D

const PART_SPRITE = preload("res://Sprites/Part.png")
const PART_CORNER = preload("res://Sprites/PartCorner.png")
const PART_TAIL = preload("res://Sprites/PartTail.png")

func _ready():
	visible = false

func _on_TimerFlash_timeout():
	visible = !visible
