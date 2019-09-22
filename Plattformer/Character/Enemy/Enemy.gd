extends "res://Character/Character.gd"

func _ready():
    SPEED = 150
    health.set_health(2)
    
    
func dead():
    is_dead = true
    $AnimatedSprite/Control.visible = false
    motion = Vector2(0,0)
    $AnimatedSprite.play("die2")
    $CollisionPolygon2D.call_deferred("set_disabled",true)
    #get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
    $Timer.start()

func hit():
    health.take_damage(1)
    $AnimatedSprite/Control._on_health_updated(0, 50)
    if health.health == 0:
        dead()
    
func _process(delta):
    if is_dead == false:
        
        motion.x = SPEED * direction
        
        if direction == 1:
                $AnimatedSprite.flip_h = false
        else:
                $AnimatedSprite.flip_h = true
        $AnimatedSprite.play("walk2")
        
        motion.y += GRAVITY
        
        motion = move_and_slide(motion, FLOOR)
    
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


func _on_AnimatedSprite_animation_finished():
    if is_dead:
        self.position.y += 30
