extends Area2D
var can_damage = true

func _on_body_entered(body):
	# Adicionamos o 'body.is_in_group("player")' aqui na checagem!
	if body.has_method("take_damage") and body.is_in_group("player") and can_damage:
		can_damage = false
		body.take_damage(1)
		await get_tree().create_timer(1.5).timeout
		can_damage = true
