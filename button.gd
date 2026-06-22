extends Button

func _pressed():
	print("clicou")
	get_tree().change_scene_to_file("res://control.tscn")
