extends Node2D

@export var preset: ChaosPreset = null

@onready var game_sprite: Sprite2D = %Game
var game_texture: ImageTexture
var game_image: Image

@onready var mouse_detect: MouseDetect = %MouseDetect
## Turned OFF when mouse enters one of the vertex handles
var should_add_points: bool = true

@onready var helper_line: Line2D = %Game/HelperLine

# Controls

@onready var panel_tool: MarginContainer = %Tool
@onready var panel_presets: MarginContainer = %Presets
@onready var run_chaos_button: Button = %RunChaosButton
@onready var clear_canvas_button: Button = %ClearCanvasButton
@onready var new_preset_button: Button = %NewPresetButton


const VERTEX_HANDLE = preload("res://vertex_handle.tscn")


func _ready() -> void:
	if preset == null:
		print("[INFO] No preset - creating a default one")
		assign_preset(ChaosPreset.new())
	
	run_chaos_button.pressed.connect(run_chaos_game)
	clear_canvas_button.pressed.connect(clear_canvas)
	new_preset_button.pressed.connect(func(): assign_preset(ChaosPreset.new()))
	
	panel_presets.on_preset_selected.connect(func(p):
		assign_preset(p)
		run_chaos_game()
	)
	
	get_viewport().size_changed.connect(func():
		var vp_rect: Rect2 = get_viewport_rect()
		game_sprite.position = Vector2(vp_rect.size.y / 2, vp_rect.size.y / 2)
	)
	
	mouse_detect.on_add_point.connect(add_point)


func add_point(uv_coords: Vector2) -> void:
	if not should_add_points:
		print("[INFO] Rejecting add_point")
		return
	
	preset.append_point(uv_coords)
	create_point_helper(uv_coords)


func run_chaos_game() -> void:
	if preset.points.size() < 2:
		print("[WARNING] Cannot run chaos game with ", preset.points.size(), " points!")
		return
	
	clear_canvas()
	
	var current_point: Vector2 = preset.points.pick_random()
	
	for i in range(preset.iterations):
		var goal: Vector2 = preset.points.pick_random()
		var move: Vector2 = (goal - current_point) * preset.ratio
		
		current_point += move
		
		if current_point.x < 0 or current_point.x >= 1 or current_point.y < 0 or current_point.y >= 1:
			continue
		
		game_image.set_pixelv(
			current_point * preset.canvas_size, 
			Color.BLACK
		)
	
	game_texture.update(game_image)


func reset_chaos_game() -> void:
	clear_canvas()
	
	preset.points.clear()
	for child in helper_line.get_children():
		child.queue_free()


func clear_canvas() -> void:
	game_image.fill(preset.background_color)
	game_texture.update(game_image)


## Called when a vertex handle is dragged. Looks at vertex handles and refreshes 
## preset points from their positions.
func recalculate_points() -> void:
	for i in helper_line.get_child_count():
		var handle = helper_line.get_child(i)
		preset.points[i] = handle.position / preset.canvas_size
		helper_line.set_point_position(i, handle.position)


## Accepts a preset from the outside, integrates its values and then assigns it 
## as the current one.
func assign_preset(p: ChaosPreset) -> void:
	clear_point_helpers()
	preset = p
	
	game_image = Image.create(preset.canvas_size, preset.canvas_size, false, Image.FORMAT_RGBA8)
	game_image.fill(preset.background_color)
	
	game_texture = ImageTexture.create_from_image(game_image)
	game_sprite.texture = game_texture
	
	mouse_detect.preset = preset
	mouse_detect.set_size(preset.canvas_size)
	
	# The image and mouse area rect are "centered" --> offset the entire helper line so that
	# it lines up nicely
	helper_line.position = -0.5 * Vector2(preset.canvas_size, preset.canvas_size)
	
	for point in preset.points:
		create_point_helper(point)
	
	# Hook up signals
	panel_tool.preset = preset
	preset.chaos_changed.connect(run_chaos_game)
	preset.ui_changed.connect(update_ui)
	


## Adds the point to helper line and creates vertex handles
func create_point_helper(uv_coords: Vector2) -> void:
	var image_coords = uv_coords * preset.canvas_size
	helper_line.add_point(image_coords)
	
	var handle = VERTEX_HANDLE.instantiate()
	handle.preset = preset
	handle.on_mouse_entered.connect(func(): should_add_points = false)
	handle.on_mouse_exited.connect(func(): should_add_points = true)
	handle.on_drag.connect(recalculate_points)
	helper_line.add_child(handle)
	handle.position = image_coords

## Clears helper line and all vertex handles
func clear_point_helpers() -> void:
	helper_line.clear_points()
	for child in helper_line.get_children():
		child.queue_free()

func update_ui() -> void:
	helper_line.default_color.a = 1 if preset.show_helper_line else 0
	
	for handle in helper_line.get_children():
		(handle as Node2D).visible = preset.show_vertices
