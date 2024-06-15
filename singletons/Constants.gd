extends Node

var EXPORTS_DIR: String = "exports"
var PRESETS_DIR: String = "chaos_presets"

var DEVELOPMENT_PRESETS_DIR: String = "res://chaos_presets"

func _enter_tree() -> void:
	if OS.has_feature("editor"):
		EXPORTS_DIR = "res://" + EXPORTS_DIR
		PRESETS_DIR = "res://" + PRESETS_DIR
	else:
		var exe_path = OS.get_executable_path()
		var prefix = "user://"
		
		match OS.get_name():
			"Windows":
				var last_slash_index = exe_path.rfindn("/")
				prefix = exe_path.erase(last_slash_index, 100) + "/"
			"macOS":
				# MacOS has the "executable" hidden in .app folder, so creating
				# a folder "next to executable" isn't that straight forward.
				var parts = exe_path.split("/")
				parts.remove_at(0) # remove empty string
				var slice = ""
				for p in parts:
					if p.contains(".app"):
						break
					slice += "/" + p
				prefix = slice + "/"
		
		EXPORTS_DIR = prefix + EXPORTS_DIR
		PRESETS_DIR = prefix + PRESETS_DIR
		
	var errors = []
	errors.append(DirAccess.make_dir_recursive_absolute(EXPORTS_DIR))
	errors.append(DirAccess.make_dir_recursive_absolute(PRESETS_DIR))
	
	await get_tree().create_timer(1).timeout
	for e in errors:
		if e != OK:
			Logger.warning("Folder setup error: " + error_string(e))
	
	
