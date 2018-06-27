extends Control

func _ready():
	$Panel/HBoxContainer/LabelParts.text = "0"

func update_food(var foods):
	$Panel/HBoxContainer/LabelParts.text = str(foods)

func update_best(var best):
	$Panel/HBoxContainer/LabelBest.text = str(best)
