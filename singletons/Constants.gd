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
			#"Windows":
				#pass
			"macOS":
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
		
		if DirAccess.dir_exists_absolute(EXPORTS_DIR) or DirAccess.dir_exists_absolute(PRESETS_DIR):
			# This is not the first launch. The  folder structure is already setup.
			Logger.info("Skipping setting up folder structure")
			return
		
		DirAccess.make_dir_recursive_absolute(EXPORTS_DIR)
		DirAccess.make_dir_recursive_absolute(PRESETS_DIR)
		

