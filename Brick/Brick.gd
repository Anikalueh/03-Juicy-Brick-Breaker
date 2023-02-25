extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

export var time_appear = 0.5
export var time_fall = 0.8
export var time_rotate = 1.0
export var time_a = 0.8
export var time_s = 1.2
export var time_v = 1.5

export var sway_amplitude = 3.0
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO

var powerup_prob = 0.1

func _ready():
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self, "position", position, new_position, 0.5 + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	sway_initial_position = $Slime.position
	sway_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)

func _physics_process(_delta):
	if dying and not $Bubbles.emitting and not $Tween.is_active():
		queue_free()
	

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Brick_Sound")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	dying = true
	collision_layer = 0
	$Brick.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	$Bubbles.emitting = true
	$Tween.interpolate_property(self, "position", position, Vector2(position.x, 1000), time_fall, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.interpolate_property(self, "rotation", rotation, -PI + randf()*2*PI, time_rotate, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
