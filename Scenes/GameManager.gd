extends Node

var save_data = {"best":0}
var savegame = File.new()
var save_path = "user://savegame.bin"

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