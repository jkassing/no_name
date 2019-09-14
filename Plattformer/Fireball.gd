extends Area2D

const SPEED = 500
var velocity = Vector2()
var direction = 1
var hit = false

func _ready():
    pass
    
func set_fireball_direction(dir):
    direction = dir
    if dir == -1:
        $AnimatedSprite.flip_h = true

func _physics_process(delta):
    if !hit:
        velocity.x = SPEED * delta * direction
        translate(velocity)
        $AnimatedSprite.play("shoot")

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()


func _on_Fireball_body_entered(body):
    if "Enemy" in body.name:
        body.hit()
    hit = true
    velocity.x = 0
    $AnimatedSprite.play("hit")
    
    
    
func _on_AnimatedSprite_animation_finished():
    if hit:
        queue_free()
        hit = false
