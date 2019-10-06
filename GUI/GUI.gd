extends CanvasLayer

onready var timeElapsed = get_node("MarginContainer/HBoxContainer/VBoxContainer/timeElapsed")
onready var hp = get_node("MarginContainer/HBoxContainer/VBoxContainer/hp")
onready var currentAction = get_node("MarginContainer/HBoxContainer/VBoxContainer/action")
onready var strength = get_node("MarginContainer/HBoxContainer/VBoxContainer2/strength")
onready var meditation = get_node("MarginContainer/HBoxContainer/VBoxContainer2/meditation")

onready var player = get_node("../Player")
onready var main = get_parent()

onready var whiteCover = get_node("../WhiteCover")
onready var choices = get_node("Choices")
onready var exerciseButton = get_node("Choices/Container/Exercise")
onready var meditateButton = get_node("Choices/Container/Meditate")

onready var button1 = get_node("Choices/Container/VBoxContainer/HBoxContainer/1")
onready var button2 = get_node("Choices/Container/VBoxContainer/HBoxContainer/2")
onready var button3 = get_node("Choices/Container/VBoxContainer/HBoxContainer2/3")
onready var button4 = get_node("Choices/Container/VBoxContainer/HBoxContainer3/4")
onready var optionsContainer = get_node("Choices/Container/VBoxContainer")

onready var speak = get_node("Speak")

onready var fight = get_node("Fight")

onready var win = get_node("Win")

onready var timer = get_node("../Timer")

onready var foodRations = get_node("MarginContainer/HBoxContainer/VBoxContainer2/slot1")
onready var slot2 = get_node("MarginContainer/HBoxContainer/VBoxContainer2/slot2")
onready var slot3 = get_node("MarginContainer/HBoxContainer/VBoxContainer2/slot3")

var wait = 3
var showOptions = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(speak.is_visible() and Input.is_action_just_pressed('accept') and ceil(player.HP)!=0 and main.time>5):
		hideButtons()
		speak.hide()
		if(showOptions):
			showOptions()
	elif(fight.is_visible() and Input.is_action_just_pressed('end_fight')):
		timer.start()
		fight.hide()
		whiteCover.hide()
		if(main.time%24>=22 or main.time%24<6):
			get_node("../Merchant").exitScene()
		player.completeFight()
	elif(win.is_visible() and Input.is_action_just_pressed('end_fight')):
		timer.start()
		win.hide()

func removeCartSlot():
	slot3.hide()

func showOptions():
	var options = player.getOptions()
	if(options[0]):
		button1.text = options[0]
		button1.show()
	if(options[1]):
		button2.text = options[1]
		button2.show()
	if(options[2]):
		button3.text = options[2]
		button3.show()
	if(options[3]):
		button4.text = options[3]
		button4.show()
	optionsContainer.show()
	choices.show()

func updateInventory(r):
	if(r>0):
		foodRations.text = "-Food rations " + str(r) + " (E)"
		slot2.text = "-"
	else:
		foodRations.text = "-"
	if(player.hasAttackedMerchant):
		slot2.text = "-Merchant cart"
		slot3.text = "(Press M to become the Merchant)"

func updateText():
	var time = main.time
	timeElapsed.text = "Day " + str(floor(time/24)) + " Hour " + str(time%24)
	hp.text = "HP: " + str(ceil(player.HP)) + "/" + str(player.maxHP)
	strength.text = "Strength " + str(player.strengthSkill)
	meditation.text = "Meditation " + str(player.meditationSkill)
	if(currentAction.text != ""):
		currentAction.text += "."
	
func isClear():
	return !choices.is_visible() and !speak.is_visible() and !fight.is_visible()
	
func removeSpeak():
	speak.hide()
	
func displayTraining():
	wait-=1
	if(!wait and !player.isMerchant):
		hideButtons()
		exerciseButton.show()
		meditateButton.show()
		choices.show()
		wait=3

func finishTraining():
	currentAction.text = ""
	
func showFight():
	timer.stop()
	clearUI()
	whiteCover.show()
	if(player.strengthSkill > 30):
		fight.get_node("Container/Text").text = "You enter the shady ring, looking giant to your oponent. You knock him out easily. The merchant, happy, gives you 2 rations! Press (F) to return."
	else:
		fight.get_node("Container/Text").text = "You enter a shady ring, throw a few punches, and soon get knocked out. The merchant hands you a food ration as agreed. Press (F) to return."
	fight.show()

func win(wintext):
	timer.stop()
	clearUI()
	win.show()
	win.get_node("Container/Text").text = wintext

func hideButtons():
	exerciseButton.hide()
	meditateButton.hide()
	optionsContainer.hide()
	button1.hide()
	button2.hide()
	button3.hide()
	button4.hide()

func _on_Exercise_pressed():
	clearUI()
	player.exercise()
	currentAction.text = "exercising"

func _on_Meditate_pressed():
	clearUI()
	player.meditate()
	currentAction.text = "meditating"
	
func clearUI():
	whiteCover.hide()
	speak.hide()
	choices.hide()
	
func speak(text, show):
	showOptions = show
	clearUI()
	speak.show()
	print(text)
	wait=3
	speak.get_node("Container/Text").text = text

func _on_1_pressed():
	clearUI()
	player.chose(0)

func _on_2_pressed():
	clearUI()
	player.chose(1)

func _on_3_pressed():
	clearUI()
	player.chose(2)


func _on_4_pressed():
	clearUI()
	player.chose(3)