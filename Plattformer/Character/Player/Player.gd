extends "res://Character/Character.gd"

const FIREBALL = preload("res://unusedRes/Object/Fireball.tscn")

var just_got_hit = false
signal got_hit

func _ready():
    GRAVITY = 40
    SPEED = 400
    JUMP_FORCE = -1200
    health.set_health(3)

# warning-ignore:unused_argument
func _physics_process(delta):
    
    if is_dead == false:
    
    #***********************************************************************************#
    # MOVEMENT
        motion.y += GRAVITY
        if Input.is_key_pressed(KEY_D):
            if is_attacking == false:
                motion.x = SPEED
                $AnimatedSprite.play("run")
                $AnimatedSprite.flip_h = false
                if sign($Position2D.position.x) == -1:
                    $RayCast2D.set_cast_to(Vector2(20,0))
                    $Position2D.position.x *= -1
            
        elif Input.is_key_pressed(KEY_A):
            if is_attacking == false:
                motion.x = -SPEED
                $AnimatedSprite.play("run")
                $AnimatedSprite.flip_h = true
                if sign($Position2D.position.x) == 1:
                    $RayCast2D.set_cast_to(Vector2(-20,0))
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
            $CollisionPolygon2D2.set_disabled(false)
            $CollisionPolygon2D.set_disabled(true)
        
        else:
            $CollisionPolygon2D.set_disabled(false)
            $CollisionPolygon2D2.set_disabled(true)
                
                
        #***********************************************************************************#
        # MELEE ATTACKS
        if Input.is_action_just_pressed("mouse_left") && !is_attacking:
            if is_on_floor():
                motion.x = 0
            is_attacking = true
            $RayCast2D.enabled = true
            $AnimatedSprite.play("attack")
        elif Input.is_action_just_pressed("mouse_right") && !is_attacking:
            if is_on_floor():
                motion.x = 0
            is_attacking = true
            $RayCast2D.enabled = true
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
            
            
        if $RayCast2D.enabled == true && $RayCast2D.is_colliding():
            if "Enemy" in $RayCast2D.get_collider().name:
                $RayCast2D.get_collider().hit()
                $RayCast2D.enabled = false
            
            
        motion = move_and_slide(motion, FLOOR)
        
        if get_slide_count() > 0:
            for i in range(get_slide_count()):
                if "Enemy" in get_slide_collision(i).collider.name:
                    hit()
        
        
func hit():
    if just_got_hit == false:
        health.take_damage(1)
        just_got_hit = true
        get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
        get_parent().get_node("Player/Camera2D/CanvasLayer/Health")._on_health_updated(0, 33)
        if health.health == 0:
            dead()      
        else:
            $HitTimer.start()
                 

func dead():
    is_dead = true
    $AnimatedSprite.play("dead")
    $CollisionPolygon2D.set_deferred("set_disabled", true)
    $CollisionPolygon2D2.set_deferred("set_disabled", true)
    $Timer.start()

func _on_AnimatedSprite_animation_finished():
    is_attacking = false
    $RayCast2D.enabled = false
    


func _on_Timer_timeout():
# warning-ignore:return_value_discarded
    get_tree().change_scene("res://Menu/TitleScreen/TitleScreen.tscn")


func _on_HitTimer_timeout():
    just_got_hit = false