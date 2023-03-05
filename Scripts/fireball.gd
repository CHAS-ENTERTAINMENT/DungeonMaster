extends Area2D

# Velocidad del proyectil, en píxeles por segundo
const SPEED = 180
# Velocidad del proyectil (puede ser negativa si va hacia la izquierda)
var speed = SPEED

# Tiempo (en segundos) que lleva vivo el proyectil
var time = 0.0
# Tiempo (en segundos) máximo antes de que el proyectil desaparezca
const LIFETIME = 20


func _process(delta):
	position.x += speed * delta
	
	# Comprobamos que el proyectil no dure más de la cuenta
	time += delta
	if time > LIFETIME:
		queue_free()


func _on_body_entered(body):
	
	# Si colisiona con el terreno, se elimina
	if body.is_in_group("Terrain"):
		self.queue_free()
	
	# Si colisiona con un enemigo, lo mata	
	if body.is_in_group("Enemies"):
		self.queue_free()
		body.queue_free()
