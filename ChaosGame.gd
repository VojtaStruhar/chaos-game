extends Node

## Runs an 'iterative' approach to chaos game. It picks vertices at random
## for an arbitrary number of iterations. Produces only approximate results,
## but depending on the number of iterations can be very fast.
## [br]
## Useful for prototyping.
func run_iterative(preset: ChaosPreset, image: Image) -> void:
	if preset.points.size() < 2:
		print("[WARNING] Cannot run chaos game with ", preset.points.size(), " points!")
		return
	
	image.fill(preset.background_color)
	
	var current_point: Vector2 = preset.points.pick_random()
	
	for i in range(preset.iterations):
		var goal: Vector2 = preset.points.pick_random()
		var move: Vector2 = (goal - current_point) * preset.ratio
		
		current_point += move
		
		if current_point.x < 0 or current_point.x >= 1 or current_point.y < 0 or current_point.y >= 1:
			continue
		
		image.set_pixelv(
			current_point * preset.canvas_size, 
			Color.BLACK
		)
