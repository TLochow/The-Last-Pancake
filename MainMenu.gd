extends Control

var TutorialPart = 0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _on_StartButton_pressed():
	$ButtonClick.play()
	SceneChanger.ChangeScene("res://Main.tscn")

func _on_TutorialButton_pressed():
	$ButtonClick.play()
	$Menu.visible = false
	$Tutorial.visible = true
	TutorialPart = 1
	ShowTutorialPart()

func ShowTutorialPart():
	if TutorialPart > 11:
		$Tutorial.visible = false
		$Menu.visible = true
	$Tutorial/Part1.visible = TutorialPart == 1
	$Tutorial/Part2.visible = TutorialPart == 2
	$Tutorial/Part3.visible = TutorialPart == 3
	$Tutorial/Part4.visible = TutorialPart == 4
	$Tutorial/Part5.visible = TutorialPart == 5
	$Tutorial/Part6.visible = TutorialPart == 6
	$Tutorial/Part7.visible = TutorialPart == 7
	$Tutorial/Part8.visible = TutorialPart == 8
	$Tutorial/Part9.visible = TutorialPart == 9
	$Tutorial/Part10.visible = TutorialPart == 10
	$Tutorial/Part11.visible = TutorialPart == 11

func _on_EndButton_pressed():
	$ButtonClick.play()
	SceneChanger.EndGame()

func _on_NextButton_pressed():
	$ButtonClick.play()
	TutorialPart += 1
	ShowTutorialPart()
