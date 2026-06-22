extends Area2D
var can_damage = true

func _on_body_entered(body):
	if body.has_method("take_damage") and can_damage:
		can_damage = false
		body.take_damage(1)
		await get_tree().create_timer(1.5).timeout
		can_damage = true
