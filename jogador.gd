extends CharacterBody2D

@onready var hitbox = $Hitbox

const SPEED: int = 75

# === Movimentação ===
func get_four_direction_vector(diagonal_allowed: bool) -> Vector2:
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	if diagonal_allowed or is_zero_approx(velocity.x):
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		elif Input.is_action_pressed("ui_down"):
			velocity.y += 1
			
	return velocity
	
func _physics_process(delta: float) -> void:
	var dir = get_four_direction_vector(true)
	velocity = dir * SPEED
	move_and_slide()
	if dir != Vector2.ZERO:
		$Sprite2D.rotation = dir.angle()
		$Hitbox.rotation = dir.angle()
	
# === Ataque ===
func _ready():
	hitbox.monitoring = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().paused = false
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	hitbox.monitoring = true
	await get_tree().create_timer(0.2).timeout
	hitbox.monitoring = false

func _on_hitbox_body_entered(body):
	if body == get_parent():
		return

	if body.has_method("take_damage"):
		body.take_damage(10)

var life = 80
var vida_maxima = 80

func heal(quantidade: float) -> void:
	life = min(life + quantidade, vida_maxima)
	print("Vida recuperada! Vida atual: ", life)

func take_damage(damage):
	if dead:
		return
	print("TOMEI DANO de:", damage)
	print("CHAMADO POR:", get_stack())
	life -= damage
	if life <= 0:
		morrer()

var dead = false

func morrer():
	if dead:
		return
	dead = true
	print("VOCÊ PERDEU")
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://derrota.tscn")
