extends Control

func _on_button_pressed():
	var game =  get_tree().get_root().get_node("Scene")
	game.start_level_by_index(game.currentLevelIndex + 1)
