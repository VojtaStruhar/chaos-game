extends PanelContainer

@export var max_log_count: int = 30
@export var info_label: LabelSettings
@export var warning_label: LabelSettings
@export var error_label: LabelSettings

@onready var logs_container: VBoxContainer = %LogsContainer


func _ready() -> void:
	Logger.logged.connect(add_log_message)

func add_log_message(type: Logger.MessageType, message: String) -> void:
	var label = Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	if type == Logger.MessageType.INFO:
		label.label_settings = info_label
	elif type == Logger.MessageType.WARNING:
		label.label_settings = warning_label
	elif type == Logger.MessageType.ERROR:
		label.label_settings = error_label
	
	label.text = message
	
	logs_container.add_child(label)
	logs_container.move_child(label, 0)
	
	# Cleanup
	var log_count = logs_container.get_child_count()
	if log_count > max_log_count:
		logs_container.remove_child(logs_container.get_child(log_count - 1))
