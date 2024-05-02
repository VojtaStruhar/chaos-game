extends Node2D

@onready var area_2d: Area2D = $Area2D

var mouse_in: bool = false
var is_dragging: bool = false

## Assigned from the parent.
var preset: ChaosPreset

signal on_mouse_entered
signal on_mouse_exited

signal on_drag

func _ready() -> void:
	area_2d.mouse_entered.connect(func():
		mouse_in = true
		on_mouse_entered.emit()
	)
	
	area_2d.mouse_exited.connect(func():
		mouse_in = false
		on_mouse_exited.emit()
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		
		if mouse_in and event.pressed and event.button_index == 1:  # left click inside
			is_dragging = true
		
		# cancel the drag even when the mouse isn't "in" the area
		if event.button_index == 1 and not event.pressed:
			is_dragging = false
	
	if is_dragging:
		if event is InputEventMouseMotion:
			event = event as InputEventMouseMotion
			position += event.relative
			on_drag.emit()
