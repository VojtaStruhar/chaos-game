extends MarginContainer

## Assigned by the main scene
var preset: ChaosPreset


@onready var export_level: SpinBox = %ExportLevel
@onready var expected_steps_label: Label = %ExpectedStepsLabel
@onready var export_button: Button = %ExportButton

@onready var accept_dialog: AcceptDialog = $AcceptDialog

func _ready() -> void:
	visibility_changed.connect(func():
		export_button.disabled = preset == null
		_update_expected_steps(export_level.value)
	)
	
	export_level.value_changed.connect(_update_expected_steps)
	export_button.pressed.connect(export)

func export() -> void:
	var export_preset: ChaosPreset = preset.duplicate(true)
	export_preset.canvas_size = 4096  # The 4K part
	
	var image: Image = Image.create(export_preset.canvas_size, export_preset.canvas_size, false, Image.FORMAT_RGBA8)
	ChaosGame.run_recursive(export_preset, image, export_level.value)
	
	var err = image.save_png("result.png")
	print(error_string(err))
	
	accept_dialog.show()

func _update_expected_steps(new_recursion_level) -> void:
	expected_steps_label.text = str(
		ChaosGame.estimate_recursive_steps(
			ChaosGame.calculate_vertex_picks(preset), 
			new_recursion_level
		)
	)
