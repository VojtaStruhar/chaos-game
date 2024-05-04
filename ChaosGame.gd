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
			preset.points_color
		)




## Runs a 'perfect' version of the chaos game up to a certain recursion level.
## No randomness - creates a perfect image, but the depth of the fractal is capped.
func run_recursive(preset: ChaosPreset, image: Image, level: int) -> void:
	if preset.points.size() < 2:
		print("[WARNING] Cannot run chaos game with ", preset.points.size(), " points!")
		return
	
	print("[INFO] Running recursive fractal drawing. Expected steps: ", pow(preset.points.size(), level))
	
	image.fill(preset.background_color)
	
	for point in preset.points:
		_recursive_fractal(preset, image, point, level)


func _recursive_fractal(preset: ChaosPreset, image: Image, current: Vector2, level: int) -> void:
	if level == 0:
		return
		
	for goal in preset.points:
		var paint_pos: Vector2 = (goal - current) * preset.ratio + current
		
		if paint_pos.x < 0 or paint_pos.x >= 1 or paint_pos.y < 0 or paint_pos.y >= 1:
			continue
		
		image.set_pixelv(
			paint_pos * preset.canvas_size, 
			preset.points_color
		)
		
		# TODO: Not sure if I shoudn't run the recursive thing for invalid positions too.
		#       Still might draw something
		
		_recursive_fractal(preset, image, paint_pos, level - 1)

	
