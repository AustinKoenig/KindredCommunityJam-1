extends KinematicBody


const GRAVITY = 500
const THROW_SPEED = 400

export var type : int

var health_change = PotionTypes.HEALTH_CHANGE[type]

var target = Vector3.ZERO
var velocity = Vector3.ZERO


func _ready() -> void:
	velocity = target * THROW_SPEED

func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	move_and_slide(velocity)
