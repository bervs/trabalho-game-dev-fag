extends Node2D

@onready var inimigos = $Inimigos

@export var proxima_fase: String = "res://vitoria.tscn"

func venceu():
	print("VOCÊ VENCEU")
	get_tree().change_scene_to_file(proxima_fase)

func _process(delta):
	if inimigos.get_child_count() == 0:
		venceu()
