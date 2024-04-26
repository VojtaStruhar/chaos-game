extends Node2D


const VERTEX_POINT = preload("res://vertex_point.tscn")

@onready var mouse_detect: MouseDetect = $MouseDetect
@onready var background: Sprite2D = $Background
@onready var helper_line: Line2D = $Line2D

## Points of the chaos polygon. Ranges are between 0 and 1, multiply by canvas size!
var points: Array[Vector2] = []

const canvas_size = 1024

var image: Image


func _ready() -> void:
	mouse_detect.point_added.connect(add_point)
	
	image = Image.create(canvas_size, canvas_size, false, Image.FORMAT_RGBA8)
	image.fill(Color.AQUA)
	background.texture = ImageTexture.create_from_image(image)
	
	helper_line.global_position = background.global_position
	

func add_point(coords: Vector2) -> void:
	points.append(coords)
	var point_world = (coords - Vector2.ONE / 2) * canvas_size
	var helper = VERTEX_POINT.instantiate()
	background.add_child(helper)
	helper.position = point_world
	
	
	helper_line.add_point(point_world)
	
	run_chaos()


func run_chaos():
	if points.size() < 3:
		print("I need at least 3 points for drawing!")
		return
	
	print("Running the chaos game")
	image.fill(Color.WHITE)
	
	var point: Vector2 = Vector2(0.5, 0.5)
	
	var ratio: float = 2 / 3.0
	print("ratio ", ratio)
	
	for i in range(250_000):
		var goal = points.pick_random()
		var move = (goal - point) * ratio
		point += move
		
		var pixel_coords = Vector2i(point * canvas_size)
		
		if pixel_coords.x < 0 or pixel_coords.x >= canvas_size or pixel_coords.y < 0 or pixel_coords.y >= canvas_size:
			continue
		
		image.set_pixelv(
			pixel_coords,
			Color.BLACK
		)
		
	(background.texture as ImageTexture).update(image)
	print("Chaos done!")


func _on_button_pressed() -> void:
	run_chaos()


func clear() -> void:
	for child in background.get_children():
		child.queue_free()
	
	points.clear()
	image.fill(Color.WHITE)
	(background.texture as ImageTexture).update(image)
	
	helper_line.clear_points()


func _on_clear_button_pressed() -> void:
	clear()
