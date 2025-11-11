class_name App extends Node

static var data := {
	"name": ProjectSettings.get_setting("application/config/name"),
	"name_localized": ProjectSettings.get_setting("application/config/name_localized"),
	"description": ProjectSettings.get_setting("application/config/description"),
	"version": ProjectSettings.get_setting("application/config/version"),
	"platform": OS.get_name().to_lower(),
	"debug_build": OS.is_debug_build() and !OS.get_name().contains("Web"),
	"web_build": OS.get_name().contains("Web")
}

static var _next_scene := preload("uid://b5q4vk5sol5pb")

func _ready() -> void:
	SceneManager.change_scene.call_deferred(_next_scene, true)
