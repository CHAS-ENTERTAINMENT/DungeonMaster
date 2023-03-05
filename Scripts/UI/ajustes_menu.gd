extends Control



func _on_check_button_toggled(button_pressed):
	get_tree().get_root().get_node("Scene").set_visual_effects(button_pressed)


func _on_main_menu_button_pressed():
	queue_free()


func _on_fullscreen_button_pressed():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if is_fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN)
