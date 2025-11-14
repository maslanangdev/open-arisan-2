extends Node

const F_TEXT := [&"", &"txt", &"conf", &"ini"]
const F_IMAGE := [&"png", &"jpg", &"jpeg", &"webp"]
const THEME := preload("res://config/themes/global.tres")

func _ready() -> void:
	if !App.data.debug_build:
		return
	if !PaperQueue.get_data().is_empty():
		return
	for d in DebugImport.data:
		_process_file(d)

func _process_file(path: StringName) -> void:
	var extension := path.get_extension().to_lower()
	
	if F_TEXT.has(extension):
		var text := FileAccess.open(path, FileAccess.READ).get_as_text()
		var spliced := text.split("\n")
		for s in spliced:
			if !s.is_empty(): _create_object(s)
		
	elif F_IMAGE.has(extension):
		var image = Image.load_from_file(path)
		var texture = ImageTexture.create_from_image(image)
		_create_object(texture)

func _create_object(data: Variant, append_data := true) -> void:
	var queue_data := {
		&"id": null,
		&"content": data,
		&"color": _get_random_color()
	}
	PaperQueue.append_data(queue_data)

func _get_random_color(saturation: float = 1.0, value: float = 1.0) -> Color:
	var random_hue = randf() 
	return Color.from_hsv(random_hue, saturation, value)
