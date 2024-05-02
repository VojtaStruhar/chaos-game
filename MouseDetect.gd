class_name MouseDetect extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var mouse_in: bool = false
var preset: ChaosPreset

signal on_add_point(Vector2)


func _ready() -> void:
	mouse_entered.connect(func(): mouse_in = true)
	mouse_exited.connect(func(): mouse_in = false)


func _process(_delta: float) -> void:
	if preset.can_add_points and mouse_in and Input.is_action_just_pressed("place_point"):
		var mpos = get_viewport().get_mouse_position()
		var rect = (collision_shape.shape as RectangleShape2D).get_rect()
		var rect_global_position = collision_shape.global_position + rect.position
		var relative_position = (mpos - rect_global_position) / rect.size
		
		on_add_point.emit(relative_position)


func set_size(size: int) -> void:
	var rect = collision_shape.shape as RectangleShape2D
	rect.size = Vector2(size, size)
	
