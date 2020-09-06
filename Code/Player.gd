extends KinematicBody2D

const UP = Vector2(0, -1)

signal grounded_changed(is_grounded)

signal health_change(health)
signal killed()

export var levels = []
var current_level = 0

onready var sprite = $Sprite
onready var wall_cooldown = $"Wall Slide Cooldown"
onready var wall_sticky_cooldown = $WallSlideSticky

var vel = Vector2.ZERO
var move_dir = 1
var move_input_speed

export (float) var speed = 25 * Global.UNIT_SIZE
export (float) var max_health = 1

onready var health = max_health
onready var death_timer = $TimeToDeath
onready var imun_time = $Imunity_Timer

var max_jump_vel
var min_jump_vel

const wall_jump_vel = Vector2(50, -38) * Global.UNIT_SIZE

var min_jump_height = 4.5 * Global.UNIT_SIZE
var max_jump_height = 5 * Global.UNIT_SIZE
var jump_time = 0.25

var is_grounded
var gravity
var is_jumping

onready var left_raycast = $wall_raycast/right_raycast
onready var right_raycast = $wall_raycast/left_raycast
var wall_dir = 1

func _ready():
	
	gravity = 2 * max_jump_height / pow(jump_time, 2)
	
	max_jump_vel = -sqrt(2 * gravity * max_jump_height)
	min_jump_vel = -sqrt(2 * gravity * min_jump_height)
	
	match get_parent().name:
		"0":
			death_timer.start(9)
		"1":
			death_timer.start(13)
	
	print("time till death is: " + str(death_timer.time_left))

func _apply_gravity(delta):
	vel.y += gravity * delta
	
	if is_jumping && vel.y >= 0:
		is_jumping = false
	
func _cap_grav_wall_slide():
	var max_vel = Global.UNIT_SIZE if !Input.is_action_pressed("move_down") else 6 * Global.UNIT_SIZE
	vel.y = min(vel.y, max_vel)
	
func _apply_movement():
	
	var was_grounded = is_grounded
	vel = move_and_slide(vel, UP)
	
	if was_grounded == null || was_grounded != is_grounded:
		emit_signal("grounded_changed", is_grounded)
	
	is_grounded = is_on_floor()
	
func _handle_wall_sticky():
	if move_dir != 0 && move_dir != wall_dir:
		if wall_sticky_cooldown.is_stopped():
			wall_sticky_cooldown.start()
		else:
			wall_sticky_cooldown.stop()
	
func jump():
	vel.y = max_jump_vel
	is_jumping = true
	
func varried_jump():
	if vel.y < min_jump_vel:
		vel.y = min_jump_vel
	
func wall_jump():
	var wall_jumpv = wall_jump_vel
	wall_jumpv.x *= -wall_dir
	vel = wall_jumpv 
	print("wall jump")
	
func _get_weight():
	if is_on_floor():
		return 0.2
	else:
		if move_dir == 0:
			return 0.02
		elif move_dir == sign(vel.x) && abs(vel.x) > speed:
			return 0.0
		else:
			return 0.1
	
func _update_input():
	move_dir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	
	if death_timer.time_left == 0:
		kill()
	
func _handle_movement(var move_speed = self.speed):
	
	move_input_speed = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	
	vel.x = lerp(vel.x, move_speed * move_input_speed, _get_weight())
	
	if move_dir != 0:
		sprite.scale.x = move_dir
		
		
func _check_is_valid_wall(raycast):	
	if raycast.is_colliding():
		print("raycast is coliding YAY!!!")
		var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
		if dot > PI * 0.35 && dot < PI * 0.55:
			return true
	return false
		
func _update_wall_dir():
	
	var is_near_wall_left = _check_is_valid_wall(left_raycast)
	var is_near_wall_right = _check_is_valid_wall(right_raycast)
	
	if is_near_wall_left && is_near_wall_right:
		wall_dir = move_dir
	else:
		wall_dir = -int(is_near_wall_left) + int(is_near_wall_right)

func damage(ammount):
	if imun_time.is_stopped():
		
		_set_health(health - ammount)
		imun_time.start()

func kill():
	print("player is dead " + "current level: " + str(current_level))
	get_tree().reload_current_scene()
	pass

func _set_health(value):
	var prev_hp = health
	
	if health != prev_hp:
		emit_signal("health_changed", health)
		
		if health == 0:
			kill()
			emit_signal("killed")


func _on_KillBox_body_entered(body):
	if body.get_name() == self.name:
		print("Player hit KillBox")
		kill()


func _on_CheckBox_body_entered(body):
	pass # Replace with function body.
