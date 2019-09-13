extends KinematicBody2D

var motion = Vector2()
export var SPEED = 400
export var GRAVITY = 40
export var JUMP_FORCE = -1200
const FLOOR = Vector2(0, -1)
var is_attacking = false


const FIREBALL = preload("res://Fireball.tscn")

func _physics_process(delta):
	
	
	#***********************************************************************************#
	# MOVEMENT
	motion.y += GRAVITY
	if Input.is_key_pressed(KEY_D):
		if is_attacking == false:
			motion.x = SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		
	elif Input.is_key_pressed(KEY_A):
		if is_attacking == false:
			motion.x = -SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		
	else:
		motion.x = 0
		if is_on_floor() && !is_attacking:
			$AnimatedSprite.play("idle")
			
			
	#***********************************************************************************#
	# JUMPING
	if is_on_floor():
		if Input.is_key_pressed(KEY_SPACE)  && !is_attacking:
			motion.y = JUMP_FORCE
	else:
		if motion.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
			
	#***********************************************************************************#
	# CROUCHING
	if Input.is_key_pressed(KEY_C) && !is_attacking:
		$AnimatedSprite.play("crouch")
		$CollisionShape2D_c.set_disabled(false)
		$CollisionShape2D.set_disabled(true)
	
	else:
		$CollisionShape2D.set_disabled(false)
		$CollisionShape2D_c.set_disabled(true)
			
			
	#***********************************************************************************#
	# MELEE ATTACKS
	if Input.is_action_just_pressed("mouse_left") && !is_attacking:
		if is_on_floor():
			motion.x = 0
		is_attacking = true
		$AnimatedSprite.play("attack")
	elif Input.is_action_just_pressed("mouse_right") && !is_attacking:
		if is_on_floor():
			motion.x = 0
		is_attacking = true
		$AnimatedSprite.play("attack2")
		
	#***********************************************************************************#
	# FIREBALL ATTACKS
	if Input.is_action_just_pressed("ui_focus_next") && !is_attacking:
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
		
	#***********************************************************************************#
		
		
	motion = move_and_slide(motion, FLOOR)

func _on_AnimatedSprite_animation_finished():
	is_attacking = false
