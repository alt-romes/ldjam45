extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var HP = 130
var maxHP = 130

var meditationSkill = 0
var strengthSkill = 0

var isMeditating = 0
var isExercising = 0

var foodRations = 0

var hasAttackedMerchant = false
var hasConvincedMerchant = false

var isMerchant = false
var isMerchantSprite = false

var canMove = false

onready var gui = get_node("../GUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed('left') and HP > 0 and !isMeditating and !isExercising and canMove):
		self.scale.x = -1
		if(self.position.x>540):
			self.position.x-=1
	elif(Input.is_action_pressed('right') and HP > 0 and !isMeditating and !isExercising and canMove):
		self.scale.x = 1
		if(self.position.x<740):
			self.position.x+=1
	if(Input.is_action_just_pressed('eat') and HP > 0):
		if(foodRations>0):
			foodRations-=1
			HP+=maxHP/3
			if(HP>maxHP):
				HP=maxHP
			gui.updateInventory(foodRations)
			gui.updateText()
	if(((Input.is_action_just_pressed("bm") and hasAttackedMerchant) or isMerchant) and HP>0):
		isMerchant = true
		if(!isMerchantSprite):
			get_node("AnimatedSprite").hide()
			get_node("Sprite").set_texture(load("res://Player/player_cart.png"))
			gui.removeCartSlot()
			isMerchantSprite=true
		self.position.x+=1
	
func getOptions():
	var two = 0
	var three = 0
	var four = 0
	if(!hasAttackedMerchant and !hasConvincedMerchant):
		if(strengthSkill>21):
			two = "Join a fight."
		if(strengthSkill>55):
			three = "Attack merchant."
		if(meditationSkill>70 and strengthSkill <= 0):
			four = "Convince merchant to meditate."
	return ['Be silent.', two, three, four]

func gameOver(reason):
	if(reason=='unknown'):
		gui.speak("GAME OVER", false)
	else:
		gui.speak(reason, false)
	if(HP>=0):
		get_node("../Timer").stop()
		HP=0
		#play player death animation
		get_node("AnimatedSprite").hide()
		get_node("Sprite").set_texture(load("res://Player/adventurer-dead.png"))

func updatePlayer():
	HP-=1
	if(ceil(HP)==0):
		gameOver('unknown')
	if(isMeditating>0):
		HP+=0.55
		maxHP+=1
		if(hasConvincedMerchant):
			HP+=1.45
			maxHP+=1
			isMeditating+=1
		meditationSkill += 1
		isMeditating-=1
	elif(isExercising>0):
		HP-=0.5
		strengthSkill+=1
		isExercising-=1
	else:
		if(!hasConvincedMerchant):
			$AnimatedSprite.play("default")
		gui.finishTraining()
		
func isIdle():
	if(isMeditating==0 and isExercising==0):
		gui.finishTraining()
		return true
	return false
	
func meditate():
	isMeditating = 4
	$AnimatedSprite.play("meditate")
	
func exercise():
	isExercising = 3
	$AnimatedSprite.play("train")
	
func completeFight():
	if(strengthSkill>33):
		foodRations += 2
	else:
		foodRations+=1
	print(foodRations)
	gui.updateInventory(foodRations)
	
func chose(n):
	if(n==0):
#		print('do nothing')
		meditationSkill+=1
	elif(n==1):
#		print('fight for food')
		if(HP<=12):
			gameOver("You were killed in the fight. You couldn't take all the hits... GAME OVER")
		else:
			gui.showFight()
			HP-=12
			strengthSkill+=6
			get_parent().time+=4
	elif(n==2):
#		print('fight merchant for his food')
		if(HP<=100):
			gameOver("You were killed by the merchant. You couldn't take all the hits... GAME OVER")
		else:
			hasAttackedMerchant = true
			gui.win("You killed the merchant despite taking a lot of damage. You keep his cart and food. You see an easy life as a merchant, with all the food you could want. Press F to continue.")
			HP-=100
			strengthSkill+=9
			foodRations+=13
			gui.updateInventory(foodRations)
			get_node("../Merchant").die()
	elif(n==3):
		hasConvincedMerchant = true
		gui.win('The merchant is impressed by your enlightment. As you ask, he comes and sits with you. The answer to life is "nothing"... Press F to continue.')
		meditate()
		meditationSkill+=24
		HP+=30
		get_node("../Merchant").liberate()
	gui.updateText()