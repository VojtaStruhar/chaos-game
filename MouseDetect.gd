class_name MouseDetect extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var mouse_in: bool = false

signal point_added(Vector2)

func _process(delta: float) -> void:
	if mouse_in and Input.is_action_just_pressed("place_point"):
		var mpos = get_viewport().get_mouse_position()
		var rect = (collision_shape.shape as RectangleShape2D).get_rect()
		var rect_global_position = collision_shape.global_position + rect.position
		var relative_position = (mpos - rect_global_position) / rect.size
		
		point_added.emit(relative_position)
		

func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false
