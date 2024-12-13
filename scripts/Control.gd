extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_exit_pressed():
	get_tree().quit()
