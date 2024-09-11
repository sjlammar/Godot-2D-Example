extends KinematicBody2D

export var max_speed_default: = Vector2(120.0, 350.0) 
export var acceleration_default: = Vector2(240, 1000.0)
export var jump_impulse: = 350.0
export var friction_default: = 0.15
export var dash_speed: = 400.0
export var dash_duration: = 0.2  
export var dash_cooldown: = 1.0 

const FLOOR_NORMAL: = Vector2.UP

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var friction: = friction_default
var direction: = Vector2.DOWN

var deb = [0,0,0]
var is_dashing: = false
var dash_timer: = 0.0
var dash_cooldown_timer: = 0.0

signal txt(arr)


func _physics_process(delta):
	var new_vel = velocity
	direction = get_move_direction()
	velocity = calculate_velocity(delta)
	
	# Cek apakah pemain sedang dash
	if is_dashing:
		dash_timer -= delta
		velocity.x = direction.x * dash_speed  # Kecepatan dash
		if dash_timer <= 0:
			is_dashing = false  # Mengakhiri dash ketika timer habis
			dash_cooldown_timer = dash_cooldown  # Mulai cooldown setelah dash
	else:
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta  # Kurangi cooldown timer
		velocity = calculate_velocity(delta)  # Hitung kecepatan normal

		# Memeriksa input dash
		if Input.is_action_just_pressed("ui_accept") and dash_cooldown_timer <= 0:
			is_dashing = true
			dash_timer = dash_duration
	
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -jump_impulse
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 4, PI/4, false)
	
	if new_vel != velocity:
		call_debugger("nilai percepatan =  "+ str(velocity),str(is_dashing),dash_cooldown_timer)

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		1.0
	)

func calculate_velocity(delta: float) -> Vector2:
	var new_velocity: = velocity
	if direction.x!=0:
		new_velocity.x += direction.x * acceleration.x * delta
		new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	else: #deaccelerate X
		new_velocity.x = approach(new_velocity.x, 0, abs(new_velocity.x*friction))
	
	#VERTICAL
	new_velocity.y += acceleration.y * delta
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	return new_velocity

static func approach(start: float, end: float, amount: float):
	if (start < end):
		return min(start + amount, end)
	else:
		return max(start - amount, end)

func call_debugger(par1,par2,par3):
	deb[0] = par1
	deb[1] = par2
	deb[2] = par3
	emit_signal("txt",deb)
