#Node2D is the name of the object the script's attached to, IDK why but godot wants me to keep that line
extends Node2D

var player = load("res://player/player.tscn").instance()  # that's the path to the player in the game files

# _process(delta) is a function that repeats itself every frames
func _process(_delta): 
	if Input.is_action_just_pressed("ui_accept") and Global.playerNumber < 2 :
            player = load("res://player/player.tscn").instance()
            
            #adds one to the number of player so that it's limited to 2
            Global.playerNumber += 1
            
            # adds the player in the level
            add_child(player)
