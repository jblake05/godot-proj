extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var jump_force = 10
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@onready var cam = $Camera3D

const CAMERA_SENSITIVITY = 0.003

var target_velocity = Vector3.ZERO
var mouse_relative_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * CAMERA_SENSITIVITY
		rotation.x = rotation.x - event.relative.y * CAMERA_SENSITIVITY
		
		

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	#if mouse_relative_pos != Vector2.ZERO:
		#print("test")
		#print(randi() % 100)

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		# $Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_force
	# Moving the Character
	velocity = target_velocity
	
	move_and_slide()
