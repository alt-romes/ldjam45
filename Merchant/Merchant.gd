extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moveToScene = false
var exitScene = false

onready var gui = get_node("../GUI")
onready var player = get_node("../Player")

var timesSpoken = 0
var canMove = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore:unused_argument
func _physics_process(delta):
	if(canMove):
		if(moveToScene):
			if(self.position.x<200):
				self.position.x+=1
			else:
				moveToScene=false
				speak()
				
		elif(exitScene):
			gui.removeSpeak()
			if(self.position.x>-104):
				self.position.x-=1
			else:
				exitScene=false
	
func enterScene():
	moveToScene = true
	self.scale.x = 1

func exitScene():
	exitScene = true
	if(canMove):
		self.scale.x = -1
	gui.clearUI()
	
func die():
	canMove = false
	#play death animation
	get_node("Sprite").set_texture(load("res://Merchant/dead_merchant.png"))
	
func liberate():
	canMove = false
	#play monk animation
	get_node("Sprite").set_texture(load("res://Merchant/merchant_meditation.png"))
	
func speak():
	var text = "I am the Merchant, I could exchange food with you... but you're not strong enough."
	var cond = true
	if(canMove):
		if(timesSpoken>=1):
			text = "You haven't been exercising enough, you will die without food! Get stronger and i'll make you a deal..."
		if(player.strengthSkill>21):
			text = "I see you have become stronger... fight for me and I'll throw you something to eat."
		timesSpoken += 1
	elif(player.hasAttackedMerchant):
		text = "(Press M to become the merchant)"
		cond = false
	elif(player.hasConvincedMerchant):
		text = "Thank you, Unknown Nude."
		cond = false
	gui.speak(text, cond)