extends CharacterBody2D


const SPEED = 30.0

var direction = Vector2.RIGHT

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var raycastL = get_node("RayCastL")
@onready var raycastR = get_node("RayCastR")
@onready var sprite   = get_node("Sprite2D")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var hueco = not raycastL.is_colliding() or not raycastR.is_colliding()
	
	var touched_wall = is_on_wall()
	if touched_wall or hueco:
		direction *= -1.0
		sprite.set_flip_h(true if direction.x < 0.0 else false)
		

	velocity = direction * SPEED
	
	move_and_slide()
