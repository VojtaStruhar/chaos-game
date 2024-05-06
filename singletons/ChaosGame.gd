extends Node

## Runs an 'iterative' approach to chaos game. It picks vertices at random
## for an arbitrary number of iterations. Produces only approximate results,
## but depending on the number of iterations can be very fast.
## [br]
## Useful for prototyping.
func run_iterative(preset: ChaosPreset, image: Image) -> void:
	if preset.points.size() < 2:
		Logger.warning("Cannot run chaos game with " + str(preset.points.size()) + " points!")
		return
	
	image.fill(preset.background_color)
	
	# Apply rules
	var vertex_picks: Dictionary = calculate_vertex_picks(preset)
	
	# No previous pick, so pick from everything. This changes later.
	var possibilities = preset.points.duplicate()
	var paint_pos: Vector2 = possibilities.pick_random()
	
	for i in range(preset.iterations):
		var goal: Vector2 = possibilities.pick_random()
		possibilities = vertex_picks[goal]
		
		var move: Vector2 = (goal - paint_pos) * preset.ratio
		
		paint_pos += move
		
		if paint_pos.x < 0 or paint_pos.x >= 1 or paint_pos.y < 0 or paint_pos.y >= 1:
			continue
		
		image.set_pixelv(
			paint_pos * preset.canvas_size, 
			preset.points_color
		)


# Compute this dict ahead of time from running a recursive (export) algorithm.
# I'll just put this here in global scope for future threaded approach.
var _recursive_picks: Dictionary = {}
var _recursive_possibilities: Array[Vector2] = []

## Runs a 'perfect' version of the chaos game up to a certain recursion level.
## No randomness - creates a perfect image, but the depth of the fractal is capped.
func run_recursive(preset: ChaosPreset, image: Image, level: int) -> void:
	if preset.points.size() < 2:
		Logger.warning("Cannot run chaos game with " + str(preset.points.size()) + " points!")
		return
	
	
	_recursive_picks = calculate_vertex_picks(preset)
	Logger.info("Running recursive fractal drawing. Estimated steps: " + str(estimate_recursive_steps(_recursive_picks, level)))
	image.fill(preset.background_color)
	
	for point in preset.points:
		_recursive_fractal(preset, _recursive_picks[point], image, point, level)


func _recursive_fractal(preset: ChaosPreset, possibilities: Array[Vector2], image: Image, current: Vector2, level: int) -> void:
	if level == 0:
		return
	
	for goal in possibilities:
		
		var paint_pos: Vector2 = (goal - current) * preset.ratio + current
		
		if paint_pos.x < 0 or paint_pos.x >= 1 or paint_pos.y < 0 or paint_pos.y >= 1:
			continue
		
		image.set_pixelv(
			paint_pos * preset.canvas_size, 
			preset.points_color
		)
		
		# TODO: Not sure if I shoudn't run the recursive thing for invalid positions too.
		#       Still might draw something
		
		_recursive_fractal(preset, _recursive_picks[goal], image, paint_pos, level - 1)

func calculate_vertex_picks(preset: ChaosPreset) -> Dictionary:
	var result = {}
	for point in preset.points:
		var point_possibilities = preset.points.duplicate()
		var current_index = point_possibilities.find(point)
		var remove_indices: Array[int] = []
		
		# Apply rules here
		if preset.rule_prevent_same_vertex:
			remove_indices.append(current_index)
		if preset.rule_prevent_next:
			remove_indices.append((current_index + 1) % preset.points.size())
		if preset.rule_prevent_next_next:
			remove_indices.append((current_index + 2) % preset.points.size())
		if preset.rule_prevent_previous:
			remove_indices.append((current_index - 1 + preset.points.size()) % preset.points.size())
		if preset.rule_prevent_previous_previous:
			remove_indices.append((current_index - 2 + preset.points.size()) % preset.points.size())
		
		# Remove (potential) duplicates
		var remove_indices_unique = []
		for i in remove_indices:
			if i not in remove_indices_unique:
				remove_indices_unique.append(i)
		
		# Remove possibilities - iterate from the end. That's the reason for the sort here.
		remove_indices_unique.sort()
		for i in range(remove_indices_unique.size()):
			var remove_index = remove_indices_unique.pop_back()
			point_possibilities.remove_at(remove_index)
		
		# Finally
		result[point] = point_possibilities
	
	return result



func estimate_recursive_steps(picks: Dictionary, level: int) -> int:
	if len(picks) == 0:
		return 0
	var total = 0
	for key in picks:
		total += picks[key].size()
	var average_picks = total / len(picks)
	return ceil(pow(average_picks, level))
