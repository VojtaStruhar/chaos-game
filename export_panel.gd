extends MarginContainer

## Assigned by the main scene
var preset: ChaosPreset

@onready var export_button: Button = $VBoxContainer/ExportButton
@onready var export_iterations: SpinBox = $VBoxContainer/HBoxContainer/ExportIterations

@onready var accept_dialog: AcceptDialog = $AcceptDialog

func _ready() -> void:
	visibility_changed.connect(func():
		export_button.disabled = preset == null
	)
	
	export_button.pressed.connect(export)

func export() -> void:
	var export_preset: ChaosPreset = preset.duplicate(true)
	export_preset.iterations = export_iterations.value
	export_preset.canvas_size = 4096
	
	var image: Image = Image.create(export_preset.canvas_size, export_preset.canvas_size, false, Image.FORMAT_RGBA8)
	ChaosGame.run_iterative(export_preset, image)
	
	var err = image.save_png("result.png")
	print(error_string(err))
	
	accept_dialog.show()
