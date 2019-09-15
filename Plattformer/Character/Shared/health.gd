extends Node2D

export (int) var health = 3

    

func _on_Player_got_hit():
  
    if health == 3:
        $HBoxContainer/health3_empty.visible = true
    if health == 2:
        $HBoxContainer/health2_empty.visible = true
    if health == 1:
        $HBoxContainer/health1_empty.visible = true
  
    health -= 1
