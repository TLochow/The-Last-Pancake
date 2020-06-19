extends Node2D

signal Eaten(EatenByPlayer)

var Moving = false
var GoingUp = false
var IsEaten = false

var Moved = 0.0

func GetEaten(up):
	IsEaten = true
	Moving = true
	GoingUp = up

func _process(delta):
	if Moving:
		var moveValue = delta * 60.0
		Moved += moveValue
		var pos = get_position()
		if GoingUp:
			pos.y -= moveValue
		else:
			pos.y += moveValue
		set_position(pos)
		
		if Moved > 65:
			$Crunch.play()
			$Sprite.visible = false
			$EatParticles.emitting = true
			$DespawnTimer.start()
			emit_signal("Eaten", not GoingUp)
			Moving = false

func _on_DespawnTimer_timeout():
	queue_free()
