extends Control

@onready var pausemenu = $"."
@onready var pauseoptions = $"../pauseoptions"
var pause = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#
#func _input(event):
	#if event.is_action_pressed("pause"):
		#toggle_pause_menu()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause_menu()
		pauseoptions.visible = false

func toggle_pause_menu():
	if pause:
		pausemenu.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		pause = !pause
		get_tree().paused = pause
	else :
		pause = !pause
		pausemenu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = pause


func _on_resume_pressed():
	toggle_pause_menu()


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_options_pressed():
	pauseoptions.visible = true
	pausemenu.visible = false


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/root_node.tscn")
