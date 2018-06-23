extends Control

var p_count = 0;

func _ready():
	$Panel/LabelParts.text = "0"

func _on_Player_eat_food():
	p_count += 1
	$Panel/LabelParts.text = str(p_count)
