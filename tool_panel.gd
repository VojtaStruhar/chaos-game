extends MarginContainer

var preset: ChaosPreset:
	set(v):
		preset = v
		build_ui()


@onready var properties_container: VBoxContainer = $VBoxContainer/PropertiesContainer

const NUMBER_FIELD = preload("res://property_fields/number_field.tscn")
const TEXT_FIELD = preload("res://property_fields/text_field.tscn")
const CHECKBOX_FIELD = preload("res://property_fields/checkbox_field.tscn")
const COLOR_FIELD = preload("res://property_fields/color_field.tscn")

func build_ui():
	
	for child in properties_container.get_children():
		child.queue_free()
	
	var props = preset.get_property_list()
	
	for prop in props:
		# This is an exported variable
		var prop_usage = prop["usage"]
		if prop_usage & PROPERTY_USAGE_EDITOR and prop_usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			#print(prop["name"], " - ", type_string(prop["type"]), "; ", prop)
			var prop_type = prop["type"]
			var field_node = null
			
			if prop_type == TYPE_FLOAT or prop_type == TYPE_INT:
				field_node = NUMBER_FIELD.instantiate()
			elif prop_type == TYPE_STRING:
				field_node = TEXT_FIELD.instantiate()
			elif prop_type == TYPE_BOOL:
				field_node = CHECKBOX_FIELD.instantiate()
			elif prop_type == TYPE_COLOR:
				field_node = COLOR_FIELD.instantiate()
			
			# If this prop has a field
			if field_node != null:
				field_node.preset = preset
				properties_container.add_child(field_node)
				field_node.setup(prop)
				
		
	
