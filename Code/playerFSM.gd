extends state_machine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	call_deferred("set_state", states.idle)

func _input(event):
	if[states.idle, states.run].has(state):
		if event.is_action_pressed("move_up"):
			parent.jump()

	elif state == states.wall_slide:
		if event.is_action_pressed("move_up"):
			parent.wall_jump()
			set_state(states.jump)

	elif state == states.jump:
		if event.is_action_released("move_up"):
			parent.varried_jump()

func _state_logic(delta):
	parent._update_input()
	parent._update_wall_dir()
	
	if state != states.wall_slide:
		parent._handle_movement()
		
	parent._apply_gravity(delta)
	
	if state == states.wall_slide:
		parent._cap_grav_wall_slide()
		parent._handle_wall_sticky()
	
	parent._apply_movement()
	
func _get_transition(delta):
	
	match state:
		states.idle:
			#print("state = idle")
			if !parent.is_on_floor():
				if parent.vel.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.vel.x != 0:
				return states.run
				
		states.run:
			#print("state = run")
			if !parent.is_on_floor():
				if parent.vel.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.vel.x == 0:
				return states.idle
				
		states.jump:
			#print("state = jump")
			if parent.wall_dir != 0:
				return states.wall_slide
			elif parent.vel.y >= 0:
				return states.fall
			elif parent.is_on_floor():
				return states.idle
				
		states.fall:
			#print("state = fall")
			if parent.is_on_floor():
				return states.idle
			elif parent.vel.y < 0:
				return states.jump
			elif parent.wall_dir != 0:
				return states.wall_slide
				
		states.wall_slide:
			print("state = wall_slide")
			if parent.is_on_floor():
				return states.idle
			elif parent.wall_dir == 0:
				return states.fall
				
	return null
	
func _enter_state(new_state, old_state):
	
	match new_state:
		states.wall_slide:
			parent.sprite.scale.x = -parent.wall_dir
			
	
func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.wall_cooldown.start()
	
	


func _on_WallSlideSticky_timeout():
	if state == states.wall_slide:
		set_state(states.fall)
