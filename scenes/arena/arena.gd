class_name Arena extends Node2D

static var instance: Arena

static var papers_nodes: Polygon2D:
	get: return instance.get_node("Papers")
static var papers_out_nodes: Node2D:
	get: return instance.get_node("PapersOut")
static var others_nodes: Node2D:
	get: return instance.get_node("Others")
static var pooled_nodes: Node2D:
	get: return instance.get_node("Pools")

func _init() -> void:
	instance = self
