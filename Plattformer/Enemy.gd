extends KinematicBody2D

const GRAVITY = 40
export(int) var speed = 150
export(int) var health = 2
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var direction = 1
var is_dead = false

func _ready():
    pass 
    
func dead():
    is_dead = true
    velocity = Vector2(0,0)
    $AnimatedSprite.play("die")
    $CollisionPolygon2D.call_deferred("set_disabled",true)
    #get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
    $Timer.start()

func hit():
    health -= 1
    if health <= 0:
        dead()
    
func _process(delta):
    if is_dead == false:
        
        velocity.x = speed * direction
        
        if direction == 1:
                $AnimatedSprite.flip_h = false
        else:
                $AnimatedSprite.flip_h = true
        $AnimatedSprite.play("walk")
        
        velocity.y += GRAVITY
        
        velocity = move_and_slide(velocity, FLOOR)
    
    if get_slide_count() > 0:
            for i in range(get_slide_count()):
                if "Player" in get_slide_collision(i).collider.name:
                    get_slide_collision(i).collider.hit()
    
    if is_on_wall():
        direction *= -1
        $RayCast2D.position.x *= -1
        
    if $RayCast2D.is_colliding() == false:
        direction *= -1
        $RayCast2D.position.x *= -1
        

func _on_Timer_timeout():
    queue_free()
