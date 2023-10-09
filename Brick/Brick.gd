extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

func _ready():
	randomize()
	position = new_position
	if score >= 100:
		$ColorRect.color = Color8(224,49,49,225)
	elif score >= 90:
		$ColorRect.color = Color8(240,101,149,225)
	elif score >= 80:
		$ColorRect.color = Color8(255,212,59,255)
	elif score >= 70:
		$ColorRect.color = Color8(54,79,199,225)
	elif score >= 60:
		$ColorRect.color = Color8(43,138,62,225)
	elif score >= 50:
		$ColorRect.color = Color8(132,94,247,255)
	elif score >= 40:
		$ColorRect.color = Color8(190,75,219,255)
	else:
		$ColorRect.color = Color8(134,46,156,225)

func _physics_process(_delta):
	if dying:
		queue_free()

func hit(_ball):
	die()

func die():
	dying = true
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
