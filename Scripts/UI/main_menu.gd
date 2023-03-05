extends Control

@onready var AjustesScreen = preload("res://Nodos/UI/ajustes_menu.tscn")
@onready var CreditsScreen = preload("res://Nodos/UI/credits.tscn")

func _on_button_pressed():
	get_tree().get_root().get_node("Scene").start_level_by_index(0)


func _on_salir_button_pressed():
	get_tree().quit()


func _on_ajustes_button_pressed():
	var screen = AjustesScreen.instantiate()
	add_child(screen)


func _on_credits_pressed():
	var screen = CreditsScreen.instantiate()
	add_child(screen)
