extends Node2D

@export var preset: ChaosPreset = null

@onready var game_sprite: Sprite2D = %Game
var game_texture: ImageTexture
var game_image: Image

@onready var mouse_detect: MouseDetect = %MouseDetect
var should_add_points: bool = true

@onready var helper_line: Line2D = %Game/HelperLine

# Controls

@onready var panel_tool: MarginContainer = %Tool
@onready var run_chaos_button: Button = %RunChaosButton

const VERTEX_HANDLE = preload("res://vertex_handle.tscn")



func _ready() -> void:
	if preset == null:
		print("No preset - creating a default one")
		preset = ChaosPreset.new()
	
	panel_tool.preset = preset
	run_chaos_button.pressed.connect(run_chaos_game)
	
	game_image = Image.create(preset.canvas_size, preset.canvas_size, false, Image.FORMAT_RGBA8)
	game_image.fill(preset.background_color)
	
	game_texture = ImageTexture.create_from_image(game_image)
	game_sprite.texture = game_texture
	
	mouse_detect.set_size(preset.canvas_size)
	mouse_detect.on_add_point.connect(add_point)
	
	# The image and mouse area rect are "centered" --> offset the entire helper line so that
	# it lines up nicely
	helper_line.position = -0.5 * Vector2(preset.canvas_size, preset.canvas_size)
	
	preset.changed.connect(run_chaos_game)


func add_point(uv_coords: Vector2) -> void:
	if not should_add_points:
		print("Rejecting add_point")
		return
	
	preset.points.append(uv_coords)
	var image_coords = uv_coords * preset.canvas_size
	helper_line.add_point(image_coords)
	
	var handle = VERTEX_HANDLE.instantiate()
	handle.preset = preset
	handle.on_mouse_entered.connect(func(): should_add_points = false)
	handle.on_mouse_exited.connect(func(): should_add_points = true)
	handle.on_drag.connect(recalculate_points)
	helper_line.add_child(handle)
	handle.position = image_coords


func run_chaos_game() -> void:
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
