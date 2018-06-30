extends Node

enum GAMESTATE {WAITING, PLAYING, GAME_OVER}
var state = GAMESTATE.WAITING

var save_data = {"best":0}
var savegame = File.new()
var save_path = "user://savegame.bin"
onready var HUD = get_node("HUD")

func change_game_state(var new_state):
	state = new_state	
	
	if state == GAMESTATE.WAITING:
		HUD.update_feedback("use arrows to move")
	elif state == GAMESTATE.GAME_OVER:
		HUD.update_feedback("game over")
	else:
		HUD.update_feedback("")

func load_game():	
	if not savegame.file_exists(save_path):
		save_game()
		return # Error! We don't have a save to load.
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()

func save_game():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()
