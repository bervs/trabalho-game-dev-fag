extends Node2D

@onready var inimigos = $Inimigos

@export var proxima_fase: String = "res://vitoria.tscn"

# Trava de segurança para não mudar de cena duas vezes
var ja_mudou_de_fase = false

func venceu():
	if ja_mudou_de_fase:
		return
		
	ja_mudou_de_fase = true
	print("VOCÊ VENCEU")
	
	# Mudança de cena segura adiada pelo Godot
	get_tree().call_deferred("change_scene_to_file", proxima_fase)

func _process(delta):
	# Só checa se ainda não mudou de fase
	if not ja_mudou_de_fase and inimigos.get_child_count() == 0:
		venceu()
