extends Node

enum MessageType { INFO, WARNING, ERROR }

signal logged(MessageType, String)

func info(message: String) -> void:
	logged.emit(MessageType.INFO, message)

func warning(message: String) -> void:
	logged.emit(MessageType.WARNING, message)

func error(message: String) -> void:
	logged.emit(MessageType.ERROR, message)
