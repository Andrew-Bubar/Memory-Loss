extends Area2D

var speed = 100 * Global.UNIT_SIZE

var move_dir = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	position += move_dir.normalized() * speed * delta
	
func setup(point_dir: Vector2):
	move_dir = point_dir
