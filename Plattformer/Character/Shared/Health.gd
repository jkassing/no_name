extends Node
class_name Health

var health: int
var shield: int

func set_health(amount : int):
    health = amount

func take_damage(damage : int):
    health -= damage

func heal(amount : int):
    health += amount