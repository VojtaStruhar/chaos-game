extends Node

var EXPORTS_DIR: String
var PRESETS_DIR: String

func _enter_tree() -> void:
	var curr = DirAccess.open(".")
	var curr_abs = curr.get_current_dir()
	
	EXPORTS_DIR = curr_abs + "/exports"
	PRESETS_DIR = curr_abs + "/chaos_presets"
	
	if not curr.dir_exists("exports"):
		curr.make_dir("exports")
		
	if not curr.dir_exists("chaos_presets"):
		curr.make_dir("chaos_presets")
	

