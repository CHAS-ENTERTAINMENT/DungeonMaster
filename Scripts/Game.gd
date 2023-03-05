extends CanvasLayer


var is_level_completed = false

# -----------------    UI    -----------------

# Nodo con el menú principal
@onready var mainMenu = get_node("MainMenu")
# Tipo del UI que se muestra al completar un nivel
@onready var UiLevelVictory = preload("res://Nodos/UI/ui_level_victory.tscn")
@onready var UiFinalVictory = preload("res://Nodos/UI/ui_final_victory.tscn")

@onready var musicPlayer = get_node("MusicPlayer")

@onready var mainMusic = preload("res://Assets/Music/xDeviruchi - Prepare for Battle! .wav")
@onready var finalMusic = preload("res://Assets/Music/PrimerBoss.wav")

var time = 0.0

func _process(delta):
	time += delta
	get_node("ColorRect").material.set_shader_parameter("time", time)

func set_visual_effects(activated):
	get_node("ColorRect").material.set_shader_parameter("is_active", activated)

# ----------------- GAMEPLAY -----------------

var current

# Tipos de los niveles
@onready var Level0 = preload("res://Nodos/Levels/level0.tscn")
@onready var Level1 = preload("res://Nodos/Levels/level1.tscn")
@onready var Level2 = preload("res://Nodos/Levels/level2.tscn")

const LAST_LEVEL_ID = 2

# Referencia al jugador
@onready var player = get_node("Player")

# Referencia al nodo del nivel actual
var currentLevel
# Índice del nivel actual
var currentLevelIndex


# Inicia el nivel indicado
func start_level(levelNodeType):
	
	# Eliminamos el nivel anterior, si existe
	if currentLevel != null:
		currentLevel.name = "XD"
		currentLevel.queue_free()
		
	var level = levelNodeType.instantiate()
	level.name = "Level"
	currentLevel = level
	add_child(level, true)
	
	is_level_completed = false
	
	# Quitamos los menús
	mainMenu.visible = false
	var victoryNode = get_node_or_null("UiLevelVictory")
	if victoryNode != null:
		victoryNode.queue_free()
	
	# Para que esté por encima del resto
	remove_child(player)
	add_child(player)
	
	var hp1 = get_node("HP/1")
	var hp2 = get_node("HP/1")
	var hp3 = get_node("HP/1")
	
	player.position =  currentLevel.get_node("SpawnPoint").position
	player.visible = true
	
	# Reactivamos todas las antorchas
	for torch in currentLevel.get_node("Antorchas").get_children():
		torch.toggle_torch(false)
	
	if player.hp < 3:
		player.set_hp(player.hp + 1)


# Inicia el nivel dado su número (empezando por 0)
func start_level_by_index(id):
	print("Starting level ", id)
	
	if id == 0:
		start_level(Level0)
		self.currentLevelIndex = id
	elif id == 1:
		start_level(Level1)
		self.currentLevelIndex = id
	elif id == 2:
		start_level(Level2)
		self.currentLevelIndex = id
		
		musicPlayer.stream = finalMusic
		musicPlayer.play()
	else:
		push_error("El nivel ", id, " no existe.")


func update_game_state():
	if currentLevel == null or is_level_completed:
		return
	
	# Obtenemos todas las antorchas, y comprobamos si están "conquistadas"
	# Si están todas conquistadas, el nivel ha sido completado
	# En caso contrario, el nivel sigue sin completarse
	for i in currentLevel.get_node("Antorchas").get_children():
		if not i.is_conquered:
			is_level_completed = false
			return
	
	is_level_completed = true
	print("Level completed!")
	
	# Mostramos el menú de victoria
	print("Current level id: " , currentLevelIndex)
	if currentLevelIndex == LAST_LEVEL_ID:
		var ui = UiFinalVictory.instantiate()
		ui.size = Vector2(320, 160)
		add_child(ui)
	else:
		var ui = UiLevelVictory.instantiate()
		ui.size = Vector2(320, 160)
		add_child(ui)

func main_menu():
	var victoryScreen = get_node_or_null("UiFinalVictory")
	if victoryScreen:
		victoryScreen.name = "XD"
		victoryScreen.queue_free()
	mainMenu.visible = true
	
	musicPlayer.stream = load("res://Assets/Music/xDeviruchi - Prepare for Battle! .wav")
	musicPlayer.play()

# Actualiza los sprites de los corazones, según la vida del jugador
func set_hp(hp):
	var first = hp >= 1
	var second = hp >= 2
	var third = hp >= 3
	
	get_node("HP/1").visible = first
	get_node("HP/2").visible = second
	get_node("HP/3").visible = third
	
	print(hp)
