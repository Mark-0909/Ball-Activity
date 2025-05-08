extends RigidBody2D


@onready var vel_and_height: Label = $"../UI/VelAndHeight"
@onready var angle_slider: HSlider = $"../UI/AngleSlider"
@onready var power_slider: HSlider = $"../UI/PowerSlider"
@onready var reset_button: Button = $"../UI/ResetButton"
@onready var bounces: Label = $"../UI/Bounces"
@onready var ball: RigidBody2D = $"."
@onready var rewards: Label = $"../UI/Rewards"

@onready var power: Label = $"../UI/Power"
@onready var angle: Label = $"../UI/Angle"


var is_released = false

var bounces_count = 0
var rewards_count = 0




func _ready() -> void:
	var angle = 15
	var speed = 100
	var direction = Vector2(cos(deg_to_rad(angle)), -sin(deg_to_rad(angle)))
	apply_impulse(direction * speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = linear_velocity
	var height = position.y
	vel_and_height.text = "Velocity: %s\nHeight: %.1f" % [velocity, height]
	
	if Input.is_action_just_pressed("Reverse_gravity"):
		gravity_scale *= -1
	
	if not is_released:
		var mouse_pos = get_viewport().get_mouse_position()
		ball.global_position = mouse_pos
	if not is_released and Input.is_action_just_pressed("Release"):
		var angle = 15
		var speed = 100
		var direction = Vector2(cos(deg_to_rad(angle)), -sin(deg_to_rad(angle)))
		apply_impulse(direction * speed)
		is_released = true

	
func launch(angle_degrees: float, power: float):
	var angle_rad = deg_to_rad(angle_degrees)
	var direction = Vector2(cos(angle_rad), - sin(angle_rad))
	apply_impulse(direction * power)
	

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var direction = (event.position - position).normalized()
		apply_impulse(direction * 300.0)
	
	

func _physics_process(delta: float) -> void:
	linear_velocity *= (1 - 0.1 * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Terrain"):
		modulate = Color(randf(), randf(), randf())
		bounces_count += 1
		bounces.text = "Bounces: %d" % bounces_count
		
		if body.is_in_group("Reward"):
			rewards_count += 1
			rewards.text = "Points: %d" % rewards_count
	ball.scale.x -= 0.5
	ball.scale.y -= 0.5


func _on_reset_button_pressed() -> void:
	bounces_count = 0
	bounces.text = "Bounces: %d" % bounces_count



func _on_reset_zone_body_entered(body: Node2D) -> void:
	bounces_count = 0
	bounces.text = "Bounces: %d" % bounces_count


func _on_angle_slider_value_changed(value: float) -> void:
	angle.text = "Angle: %d" % value
	



func _on_power_slider_value_changed(value: float) -> void:
	power.text = "Power: %d" % value
