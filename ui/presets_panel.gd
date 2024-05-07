extends MarginContainer


@onready var tree: Tree = $Tree

## Holds path to presets and their respective objects
var presets_dict: Dictionary = {}

signal on_preset_selected(ChaosPreset)

func _ready() -> void:
	tree.hide_root = true
	tree.item_selected.connect(select_preset)
	visibility_changed.connect(func():
		if visible: _populate_preset_tree
	)

func _populate_preset_tree() -> void:
	var dir = DirAccess.open(Constants.PRESETS_DIR)
	if dir:
		var err = dir.list_dir_begin()
		if err != OK:
			Logger.error("Error listing presets dir: " + error_string(err))
			return
		
		var file_name = dir.get_next()
		while file_name != "":
			var chaos_preset = ResourceLoader.load(Constants.PRESETS_DIR + "/" + file_name)
			if chaos_preset is ChaosPreset:
				presets_dict[file_name] = chaos_preset
			
			file_name = dir.get_next()
	else:
		Logger.error("An error occurred when trying to access the path.")
		return
	
	# Create the items sorted by filenames
	tree.clear()
	var tree_root = tree.create_item()
	
	var filenames = []
	for key in presets_dict:
		filenames.append(key)
	filenames.sort()
	
	for file_name in filenames:
		var chaos_preset = presets_dict[file_name]
		var item = tree_root.create_child()
		item.set_text(0, chaos_preset.name)
		item.set_metadata(0, file_name)

func select_preset() -> void:
	var selected = tree.get_selected()
	if selected == null:
		return
	
	var filename: String = selected.get_metadata(0)
	var chosen_preset: ChaosPreset = presets_dict[filename]
	
	Logger.info("Loading preset: " + chosen_preset.name)
	
	on_preset_selected.emit(chosen_preset.duplicate(true))
