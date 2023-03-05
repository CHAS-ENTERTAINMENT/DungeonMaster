extends CharacterBody2D

# Puntos de vida
var hp = 3


const LEFT = 0
const RIGHT = 1
var direction = LEFT

const SPEED = 120.0
const JUMP_VELOCITY = -200.0

const FIREBALL_COOLDOWN = 0.45
var current_fireball_cooldown = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var Fireball = preload("res://Nodos/fireball.tscn")
@onready var PauseMenu = preload("res://Nodos/UI/pause_menu.tscn")

@onready var gameInstance = get_tree().get_root().get_node("Scene")

# Entrada del usuario
func _input(event):
	if event.is_action_pressed("power") and current_fireball_cooldown <= 0.0:
		print("Power")
		
		var fireball = Fireball.instantiate()
		
		fireball.position = position
		fireball.speed = -fireball.SPEED if direction == LEFT else fireball.SPEED
		fireball.get_node("AnimatedSprite2D").set_flip_h(fireball.speed < 0.0)
		
		get_node("Fireballs").add_child(fireball)
		
		current_fireball_cooldown = FIREBALL_COOLDOWN
	
	elif event.is_action_pressed("pause"):
		print("Pause")
		
		var screen = PauseMenu.instantiate()
		gameInstance.add_child(screen)


func _process(delta):
	if current_fireball_cooldown > 0.0:
		current_fireball_cooldown -= delta

# Establece la dirección del jugador, cambiando el sprite si es necesario.
func set_direction(direction):
	if self.direction != direction:
		if direction == LEFT:
			get_node("AnimatedSprite2D").set_flip_h(false)
		elif direction == RIGHT:
			get_node("AnimatedSprite2D").set_flip_h(true)
		else:
			push_error("La dirección debe ser ", LEFT, " o ", RIGHT, ", pero se ha introducido ", direction)
			
	self.direction = direction

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Cambiamos la orientación del sprite, si es necesario
	if (direction > 0.0):
		set_direction(RIGHT)
	elif (direction < 0.0):
		set_direction(LEFT)
		
	# Establecemos la animación del sprite
	if abs(velocity.x) > 0.0:
		get_node("AnimatedSprite2D").play("walk")
	else:
		get_node("AnimatedSprite2D").play("idle")

	move_and_slide()
	
	# Comprobamos colisiones con enemigos
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i).get_collider()
		
		if collision.is_in_group("Enemies"):
			receive_damage()
			
			break

func receive_damage():
	set_hp(hp - 1)
	position = get_tree().get_root().get_node("Scene").get_node("Level/SpawnPoint").position

# Establece la vida del jugador, y actualiza los corazones de la interfaz
func set_hp(hp):
	self.hp = hp
	get_tree().get_root().get_node("Scene").set_hp(self.hp)
