extends StaticBody2D

onready var bullet = preload("res://prefab/Bullet.tscn")

onready var ray = $RayCast2D

func _process(delta):
	fire()


func fire():
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Player"):
			var temp = bullet.instance()
			add_child(temp)
			temp.global_position = global_position
			temp.rotation_degrees = rotation_degrees + 90
			temp.setup(ray.get_collision_point() - position)
	
