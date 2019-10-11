extends "res://Character/Character.gd"

const FIREBALL = preload("res://unusedRes/Object/Fireball.tscn")
onready var inventory = load("res://Items/Healing/Inventory.gd").new()
const HUD_PATH: String = "Camera2D/HUD"
var hud_node: CanvasLayer
var just_got_hit = false


func _ready():
    GRAVITY = 40
    SPEED = 400
    JUMP_FORCE = -1200
    hud_node = $Camera2D/HUD
    inventory.init(hud_node, self)
    health.set_health(100)
    health.pass_healthbar_node(hud_node.get_node("Healthbar"))
    

# warning-ignore:unused_argument
func _physics_process(delta):
    
    if is_dead == false:
    
    #***********************************************************************************#
    # MOVEMENT
        motion.y += GRAVITY
        if Input.is_key_pressed(KEY_D):
            if is_attacking == false:
                direction = 1
                motion.x = SPEED
                $AnimatedSprite.play("run")
                $AnimatedSprite.flip_h = false
                inventory.flip(false)

                if sign($FireballSpawnPoint.position.x) == -1:
                    $RayCast2D.set_cast_to(Vector2(20,0))
                    $FireballSpawnPoint.position.x *= -1
                    inventory.flip_position()
            
        elif Input.is_key_pressed(KEY_A):
            if is_attacking == false:
                motion.x = -SPEED
                $AnimatedSprite.play("run")
                $AnimatedSprite.flip_h = true
                inventory.flip(true)
                if sign($FireballSpawnPoint.position.x) == 1:
                    $RayCast2D.set_cast_to(Vector2(-20,0))
                    $FireballSpawnPoint.position.x *= -1
                    inventory.flip_position()
            
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
            $ClsnCrouching.set_disabled(false)
            $ClsnStanding.set_disabled(true)
        
        else:
            $ClsnStanding.set_disabled(false)
            $ClsnCrouching.set_disabled(true)
                
                
        if Input.is_action_just_pressed("reload"):
            if inventory.cur_rifle != null:
                inventory.cur_rifle.reload()
        
        #***********************************************************************************#
        # MELEE ATTACKS
        if Input.is_action_just_pressed("mouse_left") && !is_attacking:
            if is_on_floor():
                motion.x = 0
            is_attacking = true
            $RayCast2D.enabled = true
            $AnimatedSprite.play("attack")
        elif Input.is_action_just_pressed("mouse_right") && !is_attacking:
            if inventory.cur_rifle != null:
                inventory.cur_rifle.shoot()
            #if is_on_floor():
            #    motion.x = 0
            #is_attacking = true
            #$RayCast2D.enabled = true
            #$AnimatedSprite.play("attack2")
            
        #***********************************************************************************#
        # FIREBALL ATTACKS
        if Input.is_action_just_pressed("ui_focus_next") && !is_attacking:
            var fireball = FIREBALL.instance()
            if sign($FireballSpawnPoint.position.x) == 1:
                fireball.set_fireball_direction(1)
            else:
                fireball.set_fireball_direction(-1)
            get_parent().add_child(fireball)
            fireball.position = $FireballSpawnPoint.global_position
            
        #***********************************************************************************#
        # HEALING 
        if Input.is_action_just_pressed("heal") && inventory._can_heal():
            health.heal(50)
            inventory._use_item("HEAL")
            $Camera2D/HUD/HealthSlot/Label.text = str(inventory.current_healkits)
            print(inventory.current_healkits)
        
        
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
        health.take_damage(34)
        just_got_hit = true
        get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)
        if health.health <= 0:
            dead()      
        else:
            $HitTimer.start()
                 

func dead():
    is_dead = true
    $AnimatedSprite.play("dead")
    $ClsnStanding.set_deferred("set_disabled", true)
    $ClsnCrouching.set_deferred("set_disabled", true)
    $Timer.start()

func pick_up(item: String):
    inventory._add_item(item)

func _on_AnimatedSprite_animation_finished():
    is_attacking = false
    $RayCast2D.enabled = false
    


func _on_Timer_timeout():
# warning-ignore:return_value_discarded
    get_tree().change_scene("res://Menu/TitleScreen/TitleScreen.tscn")


func _on_HitTimer_timeout():
    just_got_hit = false

