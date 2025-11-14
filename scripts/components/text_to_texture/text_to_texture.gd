class_name TextToTexture extends BoxContainer

static var instance: TextToTexture

@onready var label := %Label
@onready var subviewport: SubViewport = %SubViewport

func _init() -> void:
	instance = self

static func get_texture_from_text(text: String) -> ImageTexture:
	var image: Image
	var texture: ImageTexture
	
	instance.label.text = text
	
	await instance.get_tree().process_frame
	image = instance.subviewport.get_texture().get_image().duplicate()
	texture = ImageTexture.create_from_image(image)
	
	return texture
