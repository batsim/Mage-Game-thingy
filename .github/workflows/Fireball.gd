extends Sprite

# a is for active it's a throaway variable so the code stops doing stuff before removing itself, cause it would cause a crash
var a = false

var damage = 10

# _on_timer_timeout() will execute itself if a timer object runs out of time, in this case it's to kill itself
func _on_Timer_timeout():

  # I put A as true so all the code that requires it stop, that's to avoid crashes
	a = true
	
  # it kills itself here by making its parent remove itself from the level
	get_parent().queue_free()
	
func _process(_delta):
	if !a:
  
    # its X coordinates move in a direction, it just checks the rotation so that it knows which direction
		if  get_parent().rotation == 0: get_parent().position.x -= 15
		else : get_parent().position.x += 15
	


# _on_Area2D_body_entered() will execute itself when the Area2D objects enters in collision with another object
func _on_Area2D_body_entered(body):

# it checks if the object has a hidden group variable called "Player", and if it doesn't, the code executes
	if !body.is_in_group("Player"):
  
    # even though some of them will be executed when a certain event happens, all functions can also just be called
		_on_Timer_timeout()
