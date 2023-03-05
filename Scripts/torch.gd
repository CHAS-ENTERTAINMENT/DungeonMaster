extends Area2D

var is_conquered = false

# Función que se ejecuta cuando el jugador colisiona con la antorcha
# y la "conquista"
func _change_torch(body):
	if body.name != "Player":
		return
	
	toggle_torch(true)
	
	get_tree().get_root().get_node("Scene").update_game_state()

func toggle_torch(is_conquered):
	self.is_conquered = is_conquered

	get_node("AnimatedNormal").visible = not is_conquered
	get_node("AnimatedConquered").visible = is_conquered
