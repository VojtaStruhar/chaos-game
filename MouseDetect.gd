class_name MouseDetect extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var preset: ChaosPreset

signal on_add_point(Vector2)

func _ready() -> void:
	input_event.connect(on_input_event)


func on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not event is InputEventMouseButton:
		return
	event = event as InputEventMouseButton
	
	if preset.can_add_points and event.pressed and event.button_index == 1:
		var mpos = event.position
		var rect = (collision_shape.shape as RectangleShape2D).get_rect()
		var rect_global_position = collision_shape.global_position + rect.position
		var relative_position = (mpos - rect_global_position) / rect.size
		
		on_add_point.emit(relative_position)

func set_size(size: int) -> void:
	var rect = collision_shape.shape as RectangleShape2D
	rect.size = Vector2(size, size)
	
