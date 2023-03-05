extends Control


func _on_button_pressed():
	var game =  get_tree().get_root().get_node("Scene")
	game.main_menu()
