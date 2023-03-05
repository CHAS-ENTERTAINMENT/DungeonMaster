extends Control


@onready var AjustesScreen = preload("res://Nodos/UI/ajustes_menu.tscn")

#Play
func _on_button_pressed():
	queue_free()


func _on_ajustes_button_pressed():
	var screen = AjustesScreen.instantiate()
	add_child(screen)


func _on_salir_button_pressed():
	get_tree().quit()
