extends Control

func _ready():
	$Panel/LabelParts.text = "0"

func update_hud(var foods):
	$Panel/LabelParts.text = str(foods)
