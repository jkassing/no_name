extends KinematicBody2D
class_name Character




const FLOOR = Vector2(0, -1)
export(int) var  SPEED
export(int) var  GRAVITY
export(int) var  JUMP_FORCE
var health: Health  = preload("res://Character/Shared/Health.gd").new()

var motion = Vector2()
var direction = 1
var is_attacking = false
var is_dead = false


