extends Area2D

class_name Luz

@export var dano_por_segundo: float = 10.0
@export var intervalo_dano: float = 1.0

# Flag para evitar que múltiplos loops de dano rodem ao mesmo tempo
var _damage_active: bool = false

func _ready() -> void:
	# Conecta os sinais de entrada e saída da área
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	# Verifica se é um jogador e se pode tomar dano
	if not body.is_in_group("player"):
		return
	if not body.has_method("take_damage"):
		return
	
	# Inicia o loop de dano se ainda não estiver ativo
	if not _damage_active:
		_damage_active = true
		_aplicar_dano(body)

func _on_body_exited(body: Node2D) -> void:
	# Interrompe o loop se o jogador sair da área
	if body.is_in_group("player"):
		_damage_active = false

func _aplicar_dano(body: Node2D) -> void:
	while _damage_active and body != null and is_instance_valid(body):
		# Confirma novamente que ainda é um jogador válido na área
		if not body.is_in_group("player"):
			break
		if not body.has_method("take_damage"):
			break
		if not overlaps_body(body):
			break

		# Aplica o dano usando o método do jogador
		body.take_damage(dano_por_segundo * intervalo_dano)

		# Espera o intervalo antes de aplicar o próximo dano
		await get_tree().create_timer(intervalo_dano).timeout

	# Libera a flag ao final do loop
	_damage_active = false
