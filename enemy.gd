extends CharacterBody2D

var life = 5
var speed = 40
var direction = Vector2.ZERO
var change_time = 0

@onready var player = get_parent().get_parent().get_node("Jogador")

func take_damage(damage):
	life -= damage
	
	modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	
	if life <= 0:
		die()

func die():
	call_deferred("queue_free")

func _physics_process(delta):
	var distance = position.distance_to(player.position)

	if distance < 100:
		var diff = position - player.position
		if diff.length() > 0:
			direction = diff.normalized()
	else:
		change_time -= delta
		
		if change_time <= 0:
			direction = Vector2(
				randf_range(-1, 1),
				randf_range(-1, 1)
			)
			if direction.length() > 0:
				direction = direction.normalized()
			change_time = randf_range(1, 3)

	velocity = direction.normalized() * speed
	move_and_slide()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
