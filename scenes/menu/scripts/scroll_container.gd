extends ScrollContainer

const SCROLL_SPEED := 100

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if UIPreviewer.active_previewer != null:
			return
		if UIPaperContainer.active_container != null:
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			AutoTween.new(self, "scroll_vertical", scroll_vertical - SCROLL_SPEED, 0.33)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			AutoTween.new(self, "scroll_vertical", scroll_vertical + SCROLL_SPEED, 0.33)
