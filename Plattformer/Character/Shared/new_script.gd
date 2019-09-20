extends Node
class_name health

var health: int
var shield: int

func take_damage(damage : int):
    health -= damage

func heal(amount : int):
    health += amount