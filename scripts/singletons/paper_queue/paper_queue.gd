extends Node

signal data_changed

var _data := [{
	&"id": null,
	&"content": null,
	&"color": Color.WHITE,
}]

func append_data(data: Dictionary) -> void:
	_data.append(data)
	data_changed.emit()

func erase_data(data: Dictionary) -> void:
	_data.erase(data)
	data_changed.emit()

func get_data() -> Array:
	return _data

func _init() -> void:
	_data.clear()
