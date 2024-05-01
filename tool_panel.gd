extends MarginContainer

var preset: ChaosPreset

@onready var iterations_spin_box: SpinBox = $VBoxContainer/IterationsField/IterationsSpinBox
@onready var ratio_spin_box: SpinBox = $VBoxContainer/RatioField/RatioSpinBox

func _ready() -> void:
	
	iterations_spin_box.value_changed.connect(
		func(val): 
			preset.iterations = val
			preset.emit_changed()
	)
	
	ratio_spin_box.value_changed.connect(
		func(val): 
			preset.ratio = val
			preset.emit_changed()
	)
	
