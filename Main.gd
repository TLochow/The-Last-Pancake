extends Node2D

var PANCAKESCENE = preload("res://Pancake.tscn")

var Pancakes = 0
var StartPancakes = 0

var Stage = "PlayerTurn"

var PancakesEaten = 0
var PlayerEats = true

var EvenUsed = false
var HalfUsed = false
var TenUsed = false

func _ready():
	Pancakes = (randi() % 11) + 10
	StartPancakes = Pancakes
	
	for i in range(Pancakes):
		var pancake = PANCAKESCENE.instance()
		pancake.connect("Eaten", self, "Pancake_Eaten")
		$Pancakes.add_child(pancake)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.ChangeScene("res://MainMenu.tscn")
	elif event.is_action_pressed("mouse_click"):
		if Stage == "End":
			$ButtonClick.play()
			SceneChanger.ChangeScene("res://MainMenu.tscn")

func _on_EnemyTimer_timeout():
	if Stage == "ComputerTurn":
		var passing = randi() % 3 == 0
		if passing:
			$EnemyPassLabel/Tween.interpolate_property($EnemyPassLabel, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$EnemyPassLabel/Tween.start()
			Stage = "PlayerTurn"
			SetPlayerButtonsEnabled(true)
		else:
			PancakesEaten = 0
			PlayerEats = false
			Stage = "EatAfterComputer"
			Eat_Pancake()

func _on_EatPancackeButton_pressed():
	if Stage == "PlayerTurn":
		$ButtonClick.play()
		Stage = "EatAfterPlayer"
		PancakesEaten = 0
		PlayerEats = true
		SetPlayerButtonsEnabled(false)
		Eat_Pancake()

func Eat_Pancake():
	var pancakes = $Pancakes.get_children()
	var pancake = pancakes[pancakes.size() - 1]
	var count = 1
	while pancake.IsEaten and pancakes.size() > count:
		count += 1
		pancake = pancakes[pancakes.size() - count]
	if PancakesEaten == 0:
		pancake.GetEaten(not PlayerEats)
	else:
		pancake.GetEaten(PlayerEats)

func Pancake_Eaten(eatenByPlayer):
	Pancakes -= 1
	if Pancakes <= 0:
		Stage = "End"
		$UI/Buttons.visible = false
		if eatenByPlayer:
			$UI/Win.visible = true
		else:
			$UI/Lost.visible = true
	else:
		PancakesEaten += 1
		if PancakesEaten <= 2:
			Eat_Pancake()
		else:
			if Stage == "EatAfterPlayer":
				Stage = "ComputerTurn"
			else:
				Stage = "PlayerTurn"
				SetPlayerButtonsEnabled(true)

func SetPlayerButtonsEnabled(enabled):
	$UI/Buttons/EatPancackeButton.disabled = not enabled
	$UI/Buttons/EvenButton.disabled = not enabled or EvenUsed
	$UI/Buttons/HalfButton.disabled = not enabled or HalfUsed
	$UI/Buttons/TenButton.disabled = not enabled or TenUsed

func _on_EvenButton_pressed():
	if Stage == "PlayerTurn" and not EvenUsed:
		$ButtonClick.play()
		EvenUsed = true
		Stage = "ComputerTurn"
		
		if Pancakes % 2 == 0:
			$UI/Buttons/EvenButton.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$UI/Buttons/EvenButton.modulate = Color(1.0, 0.0, 0.0, 1.0)
		
		SetPlayerButtonsEnabled(false)

func _on_HalfButton_pressed():
	if Stage == "PlayerTurn" and not HalfUsed:
		$ButtonClick.play()
		HalfUsed = true
		Stage = "ComputerTurn"
		
		if Pancakes <= StartPancakes / 2.0:
			$UI/Buttons/HalfButton.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$UI/Buttons/HalfButton.modulate = Color(1.0, 0.0, 0.0, 1.0)
		
		SetPlayerButtonsEnabled(false)

func _on_TenButton_pressed():
	if Stage == "PlayerTurn" and not TenUsed:
		$ButtonClick.play()
		TenUsed = true
		Stage = "ComputerTurn"
		
		if Pancakes < 10:
			$UI/Buttons/TenButton.modulate = Color(0.0, 1.0, 0.0, 1.0)
		else:
			$UI/Buttons/TenButton.modulate = Color(1.0, 0.0, 0.0, 1.0)
		
		SetPlayerButtonsEnabled(false)
