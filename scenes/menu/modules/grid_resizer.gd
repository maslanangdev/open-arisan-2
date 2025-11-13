extends Node

const GRID_SMALL := 3
const GRID_MEDIUM := 5
const GRID_LARGE := 7
const GRID_JUMBO := 10

const ASPECT_SMALL := 0.7
const ASPECT_MEDIUM := 1.4
const ASPECT_LARGE := 2.0

@onready var _grid := %GridContainer

func _ready() -> void:
	get_viewport().size_changed.connect(_update_grid)
	_update_grid.call_deferred()

func _update_grid() -> void:
	var aspect := float(get_tree().root.size.x) / float(get_tree().root.size.y)
	
	if aspect <= ASPECT_SMALL:
		_grid.columns = GRID_SMALL
	elif aspect <= ASPECT_MEDIUM:
		_grid.columns = GRID_MEDIUM
	elif aspect <= ASPECT_LARGE:
		_grid.columns = GRID_LARGE
	else:
		_grid.columns = GRID_JUMBO
