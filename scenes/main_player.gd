extends CharacterBody3D

@onready var health_bar = $camera_mount/ProgressBar
@onready var camera_mount = $camera_mount
@onready var animation_player = $main_visuals/hero2/AnimationPlayer
@onready var visuals = $main_visuals
@onready var heal_time = $Timer
var hit_impact = preload("res://scenes/hit.tscn")

var SPEED = 0
var paused = false
const JUMP_VELOCITY = 4.5
const walking = 4.0
const running = 6.5
const rolling = 8
var roll = false
var run = false
var jump = false
var locked = false
var attack = false
@export var sense_horizontal = 0.5
@export var sense_vertical = 0.5
var health = 100

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
	#print(roll)
	#print(run)
	# Add the gravity.
	if !animation_player.is_playing():
		locked = false
		attack = false
	# attack
	if Input.is_action_just_pressed("attack1"):
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if animation_player.current_animation!="slash2":
			animation_player.play("slash2")
			animation_player.seek(0.6, true)
			locked=true
			attack = true
	if Input.is_action_just_pressed("kick") and !locked:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if animation_player.current_animation!="kick":
			animation_player.play("kick")
			locked=true
	if Input.is_action_just_pressed("punch") and !locked:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if animation_player.current_animation!="punch":
			animation_player.play("punch")
			locked=true
	if not is_on_floor():
		velocity.y -= gravity * delta
	# set speed
	if Input.is_action_pressed("run"):
		SPEED = running
		run = true
		roll = false
		#print("run")
	elif Input.is_action_pressed("roll"):
		SPEED = rolling
		roll = true
		run = false
		#print("roll")
	else:
		SPEED = walking
		run = false
		roll = false
		#print("walk")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("attack2"):
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if animation_player.current_animation!="slash1":
			animation_player.play("slash1")
			locked=true
			attack = true
	if is_on_floor() and jump:
		jump = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !locked:
		if animation_player.current_animation!="jump":
			animation_player.play("jump")
			animation_player.seek(0.3, true)
			velocity.y = 6
			jump = true
			locked = true	
	if !locked:  
		if direction:
			if roll:
				if animation_player.current_animation!="roll" :
					animation_player.play("roll")
			elif run:
				if animation_player.current_animation!="run":
					animation_player.play("run")
			else:
				if animation_player.current_animation!="walk":
					animation_player.play("walk")
			
			visuals.look_at(global_position + direction)	
			# Prevent vertical rotation by zeroing out the X and Z axes
			var current_rotation = visuals.rotation_degrees
			current_rotation.x = 0  # Keep the horizontal rotation only
			current_rotation.z = 0  # Ensure no Z-axis tilt
			visuals.rotation_degrees = current_rotation
				
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation!="idle2":
				animation_player.play("idle2")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)


	move_and_slide()


func katana_on_area_3d_body_entered(body):
	if body.is_in_group("enemy") and attack:
		body.apply_damage(5)
		body.spawn_blood()
	else:
		pass
		#print(body)


func apply_damage(amount: int):
	heal_time.start(5.0)
	health -= amount
	health_bar.value = health
	if health<=0 :
		die()
	else :
		play_hit_impact()
	
	
func die():
	print("you are defeated!!!")
	get_tree().reload_current_scene()
	queue_free()


func heal_on_timer_timeout():
	if health < 100:
		health += 10
		health_bar.value = health
		heal_time.start()
	else:
		heal_time.stop()

func play_hit_impact():
	var hit = hit_impact.instantiate()
	get_tree().current_scene.add_child(hit)
	hit.global_transform.origin = $hit_point.global_transform.origin
