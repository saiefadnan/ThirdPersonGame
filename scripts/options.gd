extends Control

@onready var label = $MarginContainer/VBoxContainer/VBoxContainer2/Label
@onready var slider = $MarginContainer/VBoxContainer/VBoxContainer2/HSlider

var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	var volume_db = AudioServer.get_bus_volume_db(master_bus)
	var value = (volume_db+80)/80
	slider.value = value
	label.text = "Volume ("+ str(value)+")"

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_h_slider_value_changed(value):
	var volume_db = -80 + (value * 80)
	AudioServer.set_bus_volume_db(master_bus, volume_db)
	label.text = "Volume ("+ str(value)+")%"
