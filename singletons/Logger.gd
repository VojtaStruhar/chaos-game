extends Node

enum MessageType { INFO, WARNING, ERROR }

signal logged(MessageType, String)

func info(message: String) -> void:
	print("[INFO] ", message)
	logged.emit(MessageType.INFO, message)

func warning(message: String) -> void:
	print("[WARNING] ", message)
	logged.emit(MessageType.WARNING, message)

func error(message: String) -> void:
	print("[ERROR] ", message)
	logged.emit(MessageType.ERROR, message)
