extends CanvasLayer

@onready var vida_label = $VidaLabel
@onready var player = get_parent().get_node("Jogador")

func _process(delta):
	vida_label.text = "Vida: " + str(player.life)
