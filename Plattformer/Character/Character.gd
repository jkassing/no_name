extends KinematicBody2D

const FLOOR = Vector2(0, -1)
export(int) var  SPEED
export(int) var  GRAVITY
export(int) var  JUMP_FORCE
export(int) var health

var motion = Vector2()
var direction = 1
var is_attacking = false
var is_dead = false


func _ready():
    pass # Replace with function body.
