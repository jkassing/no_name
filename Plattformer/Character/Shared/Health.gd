extends Node
class_name Health

var health: int
var shield: int
var max_health: int = 100
var max_shield: int
var healthbar_node

func pass_healthbar_node(healtbar_in):
    healthbar_node = healtbar_in

func set_health(amount : int):
    health = amount

func set_max_health(amount : int):
    max_health = amount
    
func set_max_shield(amount : int):
    max_shield = amount
    
func take_damage(damage : int):
    health -= damage
    if healthbar_node != null:
        healthbar_node._on_health_updated(-damage)

func heal(amount : int):
    if health + amount > max_health:
        health = max_health
        var tmp = (health + amount) - health
        if healthbar_node != null:
            healthbar_node._on_health_updated(tmp)
    else:
        health += amount
        if healthbar_node != null:
            healthbar_node._on_health_updated(amount)