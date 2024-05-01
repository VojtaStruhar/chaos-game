extends Node2D

@onready var game_sprite: Sprite2D = %Game
var game_texture: ImageTexture
var game_image: Image

@onready var mouse_detect: MouseDetect = %MouseDetect
@onready var helper_line: Line2D = %Game/HelperLine


@export var preset: ChaosPreset = null


func _ready() -> void:
	if preset == null:
		preset = ChaosPreset.new()
	
	game_image = Image.create(preset.canvas_size, preset.canvas_size, false, Image.FORMAT_RGBA8)
	game_image.fill(preset.background_color)
	
	game_texture = ImageTexture.create_from_image(game_image)
	game_sprite.texture = game_texture
	
	mouse_detect.set_size(preset.canvas_size)
	mouse_detect.on_add_point.connect(add_point)

func add_point(uv_coords: Vector2) -> void:
	preset.points.append(uv_coords)
	
	var ic = (uv_coords + Vector2.ONE) * floori(preset.canvas_size / 2)
	print(uv_coords, " -> ", ic)
	
	game_image.set_pixelv(ic, Color.BLACK)
	game_texture.update(game_image)
	
	helper_line.add_point((uv_coords * preset.canvas_size) - game_sprite.global_position)
