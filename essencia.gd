extends Area2D

@export var cura: float = 15.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if body.has_method("heal"):
			body.heal(cura)
			queue_free()
