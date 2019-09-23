extends Node
class_name Health

var health: int
var shield: int
var max_health: int = 100
var max_shield: int

func set_health(amount : int):
    health = amount

func set_max_health(amount : int):
    max_health = amount
    
func set_max_shield(amount : int):
    max_shield = amount
    
func take_damage(damage : int):
    health -= damage

func heal(amount : int):
    if health + amount > max_health:
        health = max_health
    else:
        health += amount