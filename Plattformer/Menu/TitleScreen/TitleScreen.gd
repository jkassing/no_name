extends Node2D

signal sgn_start_game


func _ready():
    $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus() 

func _physics_process(delta):
    if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
        $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus() 
         
    if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
        $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()    
            
    if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton3.is_hovered() == true:
        $MarginContainer/VBoxContainer/VBoxContainer/TextureButton3.grab_focus() 

func _on_TextureButton_pressed():
    #emit_signal("sgn_start_game")
    get_tree().change_scene("res://Levels/Level_1/StageOne.tscn")

func _on_TextureButton3_pressed():
    get_tree().quit()
