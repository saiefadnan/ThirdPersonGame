extends Node3D

@export var play = false
@onready var anim = $AnimationPlayer
@onready var node = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if play:
		node.visible = true
		anim.play("slash")
	else :
		node.visible = false
