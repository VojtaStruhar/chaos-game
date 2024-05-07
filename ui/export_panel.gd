extends MarginContainer

## Assigned by the main scene
var preset: ChaosPreset

@onready var export_level: SpinBox = %ExportLevel
@onready var expected_steps_label: Label = %ExpectedStepsLabel
@onready var resolution_options: OptionButton = %ResolutionOptions
@onready var export_button: Button = %ExportButton
@onready var save_preset_button: Button = %SavePresetButton

@onready var accept_dialog: AcceptDialog = $AcceptDialog
var exports_dir: String = "exports"

# Background thread related stuff
 
@onready var background_thread_checkbox: CheckBox = %BackgroundThreadCheckbox
@onready var poll_timer: Timer = $PollTimer
var thread: Thread

signal export_complete

func _ready() -> void:
	visibility_changed.connect(func():
		if visible:
			if preset == null:
				export_button.disabled = true
			_update_expected_steps(export_level.value)
	)
	
	export_level.value_changed.connect(_update_expected_steps)
	export_button.pressed.connect(export)
	save_preset_button.pressed.connect(_save_preset)
	
	poll_timer.timeout.connect(func():
		if not thread.is_alive():
			Logger.info("Background export finished!")
			poll_timer.stop()
			export_button.disabled = false
			export_button.text = "Export image"
			export_complete.emit()
	)
	
	resolution_options.item_selected.connect(func(v): print("Selected ", v))

func export() -> void:
	var export_preset: ChaosPreset = preset.duplicate(true)
	
	var image_resolution = resolution_options.get_item_id(resolution_options.selected)
	export_preset.canvas_size = image_resolution
	
	var image: Image = Image.create(export_preset.canvas_size, export_preset.canvas_size, false, Image.FORMAT_RGBA8)
	
	var export_path = exports_dir + "/" + preset.name.to_snake_case() + "_" + resolution_options.get_item_text(resolution_options.selected) + ".png"
	
	if FileAccess.file_exists(export_path):
		Logger.error("The file you want to export already exists. Rename your preset.")
		return
	
	export_complete.connect(func():
		accept_dialog.show()
		thread.wait_to_finish()
		Logger.info("Saving export to " + export_path)
		var err = image.save_png(export_path)
		if err != OK:
			Logger.error("Failed to save exported image")
	, CONNECT_ONE_SHOT)
	
	if background_thread_checkbox.button_pressed:
		_export_background_thread(export_preset, image, export_level.value)
	else:
		_export_main_thread(export_preset, image, export_level.value)


func _export_main_thread(p: ChaosPreset, image: Image, level: int) -> void:
	ChaosGame.run_recursive(p, image, level)
	export_complete.emit()

func _export_background_thread(p: ChaosPreset, image: Image, level: int) -> void:
	Logger.info("Running export in background thread")
	poll_timer.start()
	export_button.disabled = true
	export_button.text = "Export in progress..."
	thread = Thread.new()
	thread.start(ChaosGame.run_recursive.bind(p, image, level), Thread.PRIORITY_HIGH)
	

func _update_expected_steps(new_recursion_level) -> void:
	expected_steps_label.text = str(
		ChaosGame.estimate_recursive_steps(
			ChaosGame.calculate_vertex_picks(preset), 
			new_recursion_level
		)
	)

func _save_preset() -> void:
	var dir = DirAccess.open(Constants.PRESETS_DIR)
	if dir == null:
		Logger.error("Failed to open presets directory: " + error_string(DirAccess.get_open_error()))
		return
	
	var saved_filename = preset.name.to_snake_case() + ".tres"
	if dir.file_exists(saved_filename):
		Logger.error("File " + saved_filename + " already exists. Change the name of your preset!")
		return
	
	var save_path = Constants.PRESETS_DIR + "/" + saved_filename
	ResourceSaver.save(preset, save_path)
	Logger.info("Saved preset to " + save_path)
	
