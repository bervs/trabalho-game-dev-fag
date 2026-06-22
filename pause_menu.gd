extends Control

# Menu de Pausa Definitivo para Godot 4.x
# Basta arrastar os botões nos slots do Inspetor. Se algum estiver vazio,
# o script exibe um aviso amigável no console, mas não quebra o jogo.

# Controle do jogo para notificar sobre pausa/retomada
@export var game_controller: Node

# Botões configuráveis diretamente no editor via drag-and-drop
@export var resume_button: Button
@export var restart_button: Button
@export var options_button: Button
@export var main_menu_button: Button
@export var quit_button: Button

# Caminho opcional para o menu de opções (será mostrado/ocultado ao clicar em Opções)
@export var options_menu: Control

# Indica se o jogo está pausado
var is_paused: bool = false

func _ready() -> void:
	# Inicialmente o menu de pausa fica invisível e não processa input
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Conecta os sinais de cada botão, sempre verificando se existem
	_connect_button(resume_button, _on_resume_pressed)
	_connect_button(restart_button, _on_restart_pressed)
	_connect_button(options_button, _on_options_pressed)
	_connect_button(main_menu_button, _on_main_menu_pressed)
	_connect_button(quit_button, _on_quit_pressed)

	# Oculta o menu de opções se ele existir
	if options_menu:
		options_menu.hide()

func _input(event: InputEvent) -> void:
	# Detecta o botão de pausa (ESC ou equivalente configurado no Input Map)
	if event.is_action_pressed("ui_cancel"):
		if is_paused:
			resume_game()
		else:
			pause_game()
		get_viewport().set_input_as_handled()

# Pausa o jogo e exibe o menu
func pause_game() -> void:
	is_paused = true
	get_tree().paused = true
	show()
	
	# O ato de chamar hide() automaticamente desativa a interação dos botões,
	# então não precisamos modificar focus_mode manualmente.
	# Apenas devolvemos o foco ao botão de retomar para acessibilidade/teclado.
	if resume_button:
		resume_button.grab_focus()

# Retoma o jogo e oculta o menu
func resume_game() -> void:
	is_paused = false
	get_tree().paused = false
	hide()

	# Oculta o menu de opções caso esteja aberto
	if options_menu:
		options_menu.hide()

# Conecta o sinal 'pressed' de um botão com segurança
func _connect_button(button: Button, callback: Callable) -> void:
	if button:
		# Evita conectar duas vezes se o script for reiniciado
		if not button.pressed.is_connected(callback):
			button.pressed.connect(callback)
	else:
		# Aviso amigável no console: não quebra o jogo, só informa o desenvolvedor
		push_error("PauseMenu: algum botão não foi arrastado para o slot no Inspetor. Verifique os @export variables.")

func _on_resume_pressed() -> void:
	resume_game()

func _on_restart_pressed() -> void:
	resume_game()
	# Reinicia a cena atual
	get_tree().reload_current_scene()

func _on_options_pressed () -> void:
	if options_menu:
		options_menu.show()
		hide()  # Esconde o menu principal enquanto o de opções está aberto
	else:
		push_warning("PauseMenu: botão Opções pressionado, mas nenhum options_menu foi configurado.")

func _on_main_menu_pressed() -> void:
	resume_game()
	# Muda para a cena do menu principal (ajuste o caminho conforme seu projeto)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed() -> void:
	# Sai do jogo (não funciona no editor, apenas em build exportada)
	get_tree().quit()
