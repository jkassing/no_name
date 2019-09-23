extends Node2D
class_name Inventory

var max_healkit : int = 5
var max_weapons : int = 3

var current_healkits : int = 3
var current_weapons : int = 0


func _use_item(item: String):
    if "HEAL" in item:
        current_healkits -= 1
        
    
       

func _add_item(item: String):
    if "HEAL" in item && current_healkits < max_healkit:
        current_healkits += 1


func _can_heal():
    if current_healkits > 0:
        return true
    else:
        return false

