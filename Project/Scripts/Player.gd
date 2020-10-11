extends KinematicBody

const GRAVITY = 500
const BASE_SPEED = 20
const DASH_SPEED = 200
const ACCELERATION = 100
const ANGULAR_ACCELERATION = 7
const JUMP_POWER = 100

onready var animation_tree = $PlagueDoctaModel/AnimationTree
onready var animation_state = $PlagueDoctaModel/AnimationTree.get("parameters/playback")

var direction = Vector3.ZERO
var velocity = Vector3.ZERO
var h_rotation = 0
var jump = 0

var dash = false
var dash_enabled = true


# PRIVATE METHODS

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:	
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()

func _process(delta: float) -> void:
	if direction != Vector3.ZERO:
		animation_state.travel("Armature|Walking")
	else:
		animation_state.travel("Armature|Idle")

func _physics_process(delta: float) -> void:
	# Update direction
	direction.x = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	direction.z = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	
	# Rotation
	h_rotation = $CameraRoot/H.global_transform.basis.get_euler().y
	direction = direction.rotated(Vector3.UP, h_rotation).normalized()
	
	if direction != Vector3.ZERO:
		$PlagueDoctaModel.rotation.y = lerp_angle($PlagueDoctaModel.rotation.y, $CameraRoot/H.rotation.y, delta * ANGULAR_ACCELERATION)
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		jump = JUMP_POWER
		animation_state.travel("Armature|Jump")
	else:
		jump = 0
	
	velocity.y += jump
	
	# Dash
	if Input.is_action_just_pressed("dash") and dash_enabled:
		dash = true
		dash_enabled = false
		animation_state.travel("Armature|Dash")
		$DashTimer.start()
		$DashCooldownTimer.start()
	
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0
	
	# Movement
	if direction != Vector3.ZERO:
		velocity = velocity.move_toward(direction * (BASE_SPEED + DASH_SPEED * int(dash)), delta * ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, delta * ACCELERATION)
	
	move_and_slide(velocity, Vector3(0, 1, 0))


# PUBLIC METHODS

func change_health(change: int) -> void:
	PlayerStats.health += change

# SIGNALS

func _on_DashTimer_timeout() -> void:
	dash = false

func _on_DashCooldownTimer_timeout() -> void:
	dash_enabled = true
