extends Node2D

@onready var inimigos = $Inimigos

func venceu():
	print("VOCÊ VENCEU")
	get_tree().change_scene_to_file("res://Vitoria.tscn")

func _process(delta):
	if inimigos.get_child_count() == 0:
		venceu()
