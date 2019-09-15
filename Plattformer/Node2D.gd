extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    get_tree().change_scene_to("TitleScreen")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_TitleScreen_sgn_start_game():
    get_tree().change_scene("StageOne")
