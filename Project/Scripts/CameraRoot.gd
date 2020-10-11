extends Spatial


const CAMERA_V_MAX = 80
const CAMERA_V_MIN = -50
const H_SENSITIVITY = 0.1
const V_SENSITIVITY = 0.1
const H_ACCELERATION = 10
const V_ACCELERATION = 10

var camera_rotation_h = 0
var camera_rotation_v = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_rotation_h += -event.relative.x * H_SENSITIVITY
		camera_rotation_v += event.relative.y * V_SENSITIVITY

func _physics_process(delta: float) -> void:
	camera_rotation_v = clamp(camera_rotation_v, CAMERA_V_MIN, CAMERA_V_MAX)
	
	#var mesh_front = get_parent().get_node("PlagueDoctaModel").global_transform.basis.z
	#var rotation_speed_coefficient = 0.15
	#var auto_rotate_speed = (PI - mesh_front.angle_to($H.global_transform.basis.z)) * get_parent().velocity.length() * rotation_speed_coefficient
	
	$H.rotation_degrees.y = lerp($H.rotation_degrees.y, camera_rotation_h, delta * H_ACCELERATION)
	$H/V.rotation_degrees.x = lerp($H/V.rotation_degrees.x, camera_rotation_v, delta * V_ACCELERATION)
