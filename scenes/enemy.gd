extends CharacterBody3D

var player = null
var health = 100
var dead = false
var curr_attack = false
const speed = 3.0
const attack_range = 2
const possible_attacks = ["punch", "kick"]
var blood_decal = preload("res://scenes/blood_decal.tscn")
var blood_fx = preload("res://scenes/blood_fx.tscn")

@export var player_path : NodePath

@onready var healthbar = $SubViewport/HealthBar
@onready var anim_tree = $AnimationTree
@onready var anim_play = $visual/enemy/AnimationPlayer
@onready var nav_agent = $NavigationAgent3D

func _ready():
	player = get_node(player_path)
	print(player.global_transform.origin)


func _process(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var  next_nav_point = nav_agent.get_next_path_position()
	
	if !dead:
		velocity = (next_nav_point - global_transform.origin).normalized() * speed
		look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z),Vector3.UP)
		
	

	curr_attack = possible_attacks[randi()%possible_attacks.size()]
	anim_tree.set("parameters/conditions/"+curr_attack,  _target_in_range())
		
	
	move_and_slide()
	

func _target_in_range():
	return global_position.distance_to(player.global_position) <= attack_range
	
func apply_damage(amount: int):
	print("amount",amount)
	print("enemy health",health)
	health -= amount
	healthbar.value = health
	print("enemy health",health)
	if health <=0 :
		dead = true
		die()
	else:
		anim_play.play("idle")
		await get_tree().create_timer(1).timeout
		anim_play.stop()
		
func die():
	anim_tree.set("parameters/conditions/die", true)
	await get_tree().create_timer(3).timeout
	print("enemy defeated!!!")
	queue_free()



func rightleg_on_area_3d_body_entered(body):
	if body.is_in_group("player") and curr_attack == "kick":
		body.apply_damage(10)


func rightfoot_on_area_3d_body_entered(body):
	if body.is_in_group("player") and curr_attack == "kick":
		body.apply_damage(10)


func righthand_on_area_3d_body_entered(body):
	if body.is_in_group("player") and curr_attack == "punch":
		body.apply_damage(10)
		
func spawn_blood():
	var dec = blood_decal.instantiate()
	var fx = blood_fx.instantiate()
	get_tree().current_scene.add_child(dec)
	get_tree().current_scene.add_child(fx)
	dec.global_transform.origin = $blood_spawn.global_transform.origin
	fx.global_transform.origin = $blood_fx.global_transform.origin
