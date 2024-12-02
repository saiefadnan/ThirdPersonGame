extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
@onready var visuals = $visuals
var SPEED = 0
const JUMP_VELOCITY = 4.5
const walking = 4.0
const running = 6.5
var run = false
var locked = false
@export var sense_horizontal = 0.5
@export var sense_vertical = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sense_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x*sense_horizontal))	
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sense_vertical))

func _physics_process(delta):
	# Add the gravity.
	if !animation_player.is_playing():
		locked = false
	if Input.is_action_just_pressed("kick"):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if animation_player.current_animation!="kick":
			animation_player.play("kick")
			locked=true
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_pressed("run"):
		SPEED = running
		run = true
	else:
		SPEED = walking
		run = false
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !locked:
		if direction:
			if run:
				if animation_player.current_animation!="running":
					animation_player.play("running")
			else:
				if animation_player.current_animation!="walking":
					animation_player.play("walking")
			
			visuals.look_at(global_position + direction)	
				
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation!="idle":
				animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
		
