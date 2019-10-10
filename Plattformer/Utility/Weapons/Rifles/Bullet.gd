extends Area2D

export(float) var SPEED = 1500
var damage : int
var direction : int


func _ready():
    set_as_toplevel(true)


func _process(delta):
    position.x += direction * SPEED * delta


func _on_VisibilityNotifier2D_screen_exited():
    queue_free() 


func _on_Bullet_body_entered(body):
    if body.is_in_group("Enemy"):
        body.hit()  # .deal_damage(damage)
    queue_free()
