extends Timer

onready var merchant = get_node("../Merchant")
onready var player = get_node("../Player")
onready var gui = get_node("../GUI")
onready var main = get_parent()


func hourPassed():
	main.time += 1
	var time = main.time
	if(time%24==6 and int(floor(time/24))%2==0):
		#called merchant
		merchant.enterScene()
	elif(time%24==22 and int(floor(time/24))%2==0):
		#merchant left
		merchant.exitScene()
	if(time>11 and gui.isClear() and player.isIdle()):
		gui.displayTraining()
	elif(time==4):
		gui.clearUI()
	elif(time==1):
		player.canMove=true
	if(player.isMerchant):
		player.foodRations+=1
		gui.updateInventory(player.foodRations)
	player.updatePlayer()
	gui.updateText()