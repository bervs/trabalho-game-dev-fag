extends CharacterBody2D

# === Atributos do Boss ===
var life = 100       
var speed = 65       # Aumentei um pouquinho a velocidade para ele ficar mais perigoso solto
var direction = Vector2.ZERO
var change_time = 0

func take_damage(damage):
	life -= damage
	
	# Efeito visual de dano (piscar em vermelho)
	modulate = Color(1, 0.2, 0.2)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	
	print("Vida do Boss: ", life)
	
	if life <= 0:
		die()

func die():
	print("BOSS DERROTADO!")
	
	# Avisa a sala diretamente que o jogador venceu
	var sala = get_parent().get_parent()
	if sala and sala.has_method("venceu"):
		sala.venceu()
		
	call_deferred("queue_free")

func _physics_process(delta):
	# === Lógica de Movimento Aleatório ===
	# O temporizador diminui a cada frame
	change_time -= delta
	
	# Quando o tempo zera, ele escolhe uma nova direção
	if change_time <= 0:
		direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		)
		
		if direction.length() > 0:
			direction = direction.normalized()
			
		# Escolhe quanto tempo vai andar nessa direção (entre 1 e 3 segundos)
		change_time = randf_range(1, 3)

	# Aplica a velocidade e move o Boss
	velocity = direction * speed
	move_and_slide()

# Se o corpo do Boss encostar no jogador, dá dano
func _on_body_entered(body):
	# Verifica se quem bateu tem a função de tomar dano e se chama "Jogador"
	if body.has_method("take_damage") and body.name == "Jogador":
		body.take_damage(10) # Boss arranca 10 de vida por toque!
