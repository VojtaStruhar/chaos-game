extends MarginContainer

@export_dir var presets_dir_path: String

@onready var tree: Tree = $Tree

## Holds path to presets and their respective objects
var presets_dict: Dictionary = {}

signal on_preset_selected(ChaosPreset)

func _ready() -> void:
	var dir = DirAccess.open(presets_dir_path)
	var tree_root = tree.create_item()
	tree.hide_root = true
	
	tree.item_selected.connect(select_preset)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			
			var chaos_preset = ResourceLoader.load(presets_dir_path + "/" + file_name)
			if chaos_preset is ChaosPreset:
				presets_dict[file_name] = chaos_preset
				var item = tree_root.create_child()
				item.set_text(0, chaos_preset.name)
				item.set_metadata(0, file_name)
			
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func select_preset() -> void:
	var selected = tree.get_selected()
	if selected == null:
		return
	
	var filename: String = selected.get_metadata(0)
	var chosen_preset: ChaosPreset = presets_dict[filename]
	
	on_preset_selected.emit(chosen_preset.duplicate(true))
