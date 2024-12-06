extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	await get_tree().create_timer(1.0,false).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
