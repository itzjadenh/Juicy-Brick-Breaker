extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var time_appear = 0.5
var time_fall = 1.4
var time_rotate = 2.0
var time_a = 0.8
var time_s = 1.2
var time_v = 1.5
var tween
var powerup_prob = 0.1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	position.x = new_position.x
	position.y = -100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	
	
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
	if dying and not $Confetti.emitting and not tween:
		queue_free()

func hit(_ball):
	die()

func die():
	dying = true
	$CollisionShape2D.queue_free()
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	$Confetti.emitting = true
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	if tween:
		tween.kill()
		tween = create_tween().set_parallel(true)
		tween.tween_property(self, "position", Vector2(position.x,1000), time_fall).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "rotation", -PI + randf()*2*PI,time_rotate).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
