extends Node2D
class_name Inventory

var parent_node
var hud_node: CanvasLayer

var max_healkit : int = 5
var max_weapons : int = 3

var current_healkits : int = 3
var current_weapons : int = 0
var RIFLE = preload("res://Items/Weapons/Rifles/Rifle.tscn")
var rifle
var cur_rifle = null

func init(hud_node_in: CanvasLayer, parent_node_in):
    assert(hud_node_in != null)
    hud_node = hud_node_in
    parent_node = parent_node_in
    

func flip(flip: bool):
    if cur_rifle != null:
        rifle.flip_h = flip

func flip_position():
    rifle.position.x *= -1
    rifle.get_node("BulletSpawn").position.x *= -1


func _use_item(item: String):
    if "HEAL" in item:
        current_healkits -= 1
     

func _add_item(item: String):
    if "HEAL" in item && current_healkits < max_healkit:
        current_healkits += 1
    if "Rifle" == item:
        rifle = RIFLE.instance()
        rifle.pass_hud_node(hud_node.get_node("RifleSlot"))
        parent_node.add_child(rifle)
        cur_rifle = rifle
        hud_node.get_node("RifleSlot/Frame/Rifle").texture = load("res://Sprites/Indvidual Sprites/Guns/gun.png")


func _can_heal():
    if current_healkits > 0:
        return true
    else:
        return false
