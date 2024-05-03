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

const GROUP_PANEL = preload("res://property_fields/group_panel.tscn")

func build_ui():
	
	for child in properties_container.get_children():
		properties_container.remove_child(child)
		child.queue_free()
	
	var properties_target: Control = properties_container
	
	var props = preset.get_property_list()
	
	for prop in props:
		var prop_usage = prop["usage"]
		
		# This is a shadow property indicating the start of a group. 
		# Put all following fields into a special panel.
		if prop_usage & PROPERTY_USAGE_GROUP:
			properties_target = GROUP_PANEL.instantiate()
			properties_target.name = prop["name"]
			properties_container.add_child(properties_target)
			continue
		
		# This is a custom exported variable - that's what we want
		if prop_usage & PROPERTY_USAGE_EDITOR and prop_usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
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
				
				if properties_target.has_method("add_field"):
					properties_target.add_field(field_node)
				else:
					properties_target.add_child(field_node)
					
				field_node.setup(prop)
				
		
	
