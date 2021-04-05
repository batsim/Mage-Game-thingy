extends KinematicBody2D

# this one's long so buckle your seatbelt

var assignedNumber = 0 #some script acts differently if you're player one/two

var Fireball = load("res://player/Fireball.tscn").instance() # accesses the path to the fireball so that it can add it later

onready var timer = $Timer # acceses the timer object ($ is used to get access to a node)
onready var bar = $ProgressBar # acceses the progressbar object

# buncha useless stuff
var health = 100
var speed = 5
var gravity = 30
var flipped = false
var cooldowned = false

# I don't know what this exactly does but it's integral if you want to have collisions and stuff
var velocity = Vector2.ZERO

# _ready() will execute itself when the player is added to a scene
func _ready():
	if Global.playerNumber == 1 :
		assignedNumber = 1
    
    # that just changes your texture depending on whether you're player 1 or 2
		get_node("sprite").texture = load("res://sprites/PlayerGbSprite.png")
	if Global.playerNumber == 2 : 
		assignedNumber = 2
		get_node("sprite").texture = load("res://sprites/PlayerARQSprite.png")

func _process(delta):
	bar.value = health # the progressbar's value is set to the health so that it's alway's right
	if assignedNumber == 1 :
		mouv1()
	if assignedNumber == 2 :
		mouv2()
	velocity.y += gravity
	velocity = move_and_slide(velocity)

# that's a custom function that only executes itself when I call it, it's the same as Mouv1() but with player 2's controls, so I'll only explain this one
func mouv2():
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_A) : 
		position.x -= speed # changes position based on speed
		get_node("sprite").set_flip_h(true) #reverses the sprite's direction 
		flipped = true
	if Input.is_key_pressed(KEY_D) : 
		position.x += speed
		get_node("sprite").set_flip_h(false)
		flipped = false
	if Input.is_key_pressed(KEY_S) : 
		scale.y = 0.25 # its normal scale is 0.25
		gravity = 30 # normal gravity
	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_W) :
		scale.y = -0.25 # reverses player's Y scale (puts him backward)
		gravity = -30 # gravity goes up
   
	if Input.is_key_pressed(KEY_E) and !cooldowned :
		Fireball = load("res://player/Fireball.tscn").instance()
		$"../".add_child(Fireball) #  $"../" means "get the parent node", so the parent adds a fireball
		Fireball.get_node("Sprite").texture = load("res://sprites/FireballARQ4.png") # the fireball texure changes because it can have 2 colours depending on player 1/2
		if !flipped: Fireball.rotation_degrees = 180 # that just makes the fireball go left if you look left
		Fireball.position = position # please tell me that I don't have to explain this one
		cooldowned = true # you can only throw a fireball while it's set to false
		timer.start() # this one explains itself pretty well

# same as mouv2() so I won't explain it
func mouv1():
	#position.y -= gravity
	if Input.is_key_pressed(KEY_LEFT) : 
		position.x -= speed
		get_node("sprite").set_flip_h(true)
		flipped = true
	if Input.is_key_pressed(KEY_RIGHT) : 
		position.x += speed
		get_node("sprite").set_flip_h(false)
		flipped = false
	if Input.is_key_pressed(KEY_DOWN) : 
		scale.y = 0.25
		gravity = 30
	if Input.is_key_pressed(KEY_UP) :
		scale.y = -0.25
		gravity = -30
	if Input.is_key_pressed(KEY_SHIFT) and !cooldowned :
		Fireball = load("res://player/Fireball.tscn").instance()
		$"../".add_child(Fireball)
		Fireball.get_node("Sprite").texture = load("res://sprites/FireballGB.png")
		if !flipped: Fireball.rotation_degrees = 180
		Fireball.position = position
		cooldowned = true
		timer.start()


func _on_Timer_timeout():
	cooldowned = false # sets the cooldowned effect back to false once the timer's finished


func _on_Area2D_area_entered(body):

# this one damages you if it's in a group named "hurt"
	if body.is_in_group("Hurt"):
		health -= body.get_node("../Sprite").damage
