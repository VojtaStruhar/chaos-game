extends MarginContainer

## Assigned by the main scene
var preset: ChaosPreset


@onready var export_level: SpinBox = %ExportLevel
@onready var expected_steps_label: Label = %ExpectedStepsLabel
@onready var resolution_options: OptionButton = %ResolutionOptions
@onready var export_button: Button = %ExportButton

@onready var accept_dialog: AcceptDialog = $AcceptDialog

var exports_dir: String = "exports"

func _ready() -> void:
	visibility_changed.connect(func():
		export_button.disabled = preset == null
		_update_expected_steps(export_level.value)
	)
	var d = DirAccess.open(".")  # Current directory, from where the binary is run
	d.make_dir(exports_dir)
	
	
	export_level.value_changed.connect(_update_expected_steps)
	export_button.pressed.connect(export)
	
	resolution_options.item_selected.connect(func(v): print("Selected ", v))

func export() -> void:
	var export_preset: ChaosPreset = preset.duplicate(true)
	
	var image_resolution = resolution_options.get_item_id(resolution_options.selected)
	export_preset.canvas_size = image_resolution
	
	var image: Image = Image.create(export_preset.canvas_size, export_preset.canvas_size, false, Image.FORMAT_RGBA8)
	ChaosGame.run_recursive(export_preset, image, export_level.value)
	
	accept_dialog.show()
	Logger.info("Export complete")
	var export_path = exports_dir + "/" + preset.name.to_snake_case() + "_" + resolution_options.get_item_text(resolution_options.selected) + ".png"
	
	Logger.info("Saving export to " + export_path)
	var err = image.save_png(export_path)
	if err != OK:
		Logger.error("Failed to save exported image")
	

func _update_expected_steps(new_recursion_level) -> void:
	expected_steps_label.text = str(
		ChaosGame.estimate_recursive_steps(
			ChaosGame.calculate_vertex_picks(preset), 
			new_recursion_level
		)
	)
