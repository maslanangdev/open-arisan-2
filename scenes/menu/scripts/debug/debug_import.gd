class_name DebugImport extends Node

@onready var _data_importer := owner.get_node("Scripts/DataImporter")

const data := [
	"/home/baidu/Pictures/Artists References/30413138_p0 - 寮のにちじょう.jpg",
	"/home/baidu/Pictures/Artists References/34459577_p0 - 【PFNW】 閉じ込められた.jpg",
	"/home/baidu/Pictures/Artists References/35614903_p0 - 狂喜と贖罪の剣.jpg",
	"/home/baidu/Pictures/Artists References/99249216_p0 - 绫华 · 守护.jpg",
	"/home/baidu/Pictures/Artists References/99280256_p0 - 无题.jpg",
	"/home/baidu/Pictures/Artists References/99316043_p0 - 無題.png",
	"/home/baidu/Pictures/Artists References/99320625_p0 - SARIA.jpg",
	"/home/baidu/Pictures/Artists References/99486664_p0 - 77日目,チルノ.jpg",
	"/home/baidu/Pictures/Artists References/99508251_p0 - 78日目,十六夜 咲夜.jpg",
	"/home/baidu/Pictures/Artists References/99523172_p1 - 異世界アイドル- ゔぃちゃん.jpg",
	"/home/baidu/Pictures/Artists References/99528765_p0 - 79日目,フランドール・スカーレット.jpg",
	"/home/baidu/Pictures/Artists References/99549359_p0 - 80日目,藤原妹紅.jpg",
	"/home/baidu/Pictures/Artists References/99575372_p0 - Quest Complete.png",
	"/home/baidu/Pictures/Artists References/99585054_p0 - rEst.jpg",
	"/home/baidu/Pictures/Artists References/99591545_p0 - 82日目,纏流子,83日目,鬼龍院皐月.jpg",
	#"/home/baidu/Pictures/Artists References/99705960_p0 - 87日目,セレスティア・ルーデンベルク.jpg",
	#"/home/baidu/Pictures/Artists References/99746284_p0 - ドライブ.jpg",
	#"/home/baidu/Pictures/Artists References/99765590_p0 - あなたの心 · フィッシュル.jpg",
	#"/home/baidu/Pictures/Artists References/99800702_p0 - 91日目,レーシングミク2022.jpg",
	#"/home/baidu/Pictures/Artists References/99850217_p0 - 监视.jpg",
	#"/home/baidu/Pictures/Artists References/99964162_p0 - Void.jpg",
	#"/home/baidu/Pictures/Artists References/99973718_p0 - 98日目,城ヶ崎美嘉.jpg",
	#"/home/baidu/Pictures/Artists References/99978536_p0 - nilu.jpg"
]

func _ready() -> void:
	if !App.data.debug_build:
		return
	if !PaperQueue.get_data().is_empty():
		return
	await get_tree().physics_frame
	_initialize.call_deferred()
	
func _initialize() -> void:
	for d in data:
		_data_importer._process_file(d)
