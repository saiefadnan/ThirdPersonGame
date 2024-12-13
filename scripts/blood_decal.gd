extends Decal


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(10.0,false).timeout
	queue_free()
