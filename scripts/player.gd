extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_group: Node2D = $"Sprite Group"
@onready var original_scale_x: float = sprite_group.scale.x
@onready var timer: Timer = $Timer

@export var cayote_time: float = 1

const MAX_SPEED = 300
const ACCELERATION = 400.0
const DECELERATION = 300.0
const JUMP_VELOCITY = 750.0
const ANIMATION_SPEED_MULTIPLIER = 1.2

var can_jump : bool = true

func _ready() -> void:
	timer.wait_time = cayote_time

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		timer.start()
		if velocity.y < 0:
			velocity += get_gravity() * delta * 3
		else:
			velocity += get_gravity() * delta * 0.8
	else: 
		can_jump = true
	
	# Handle jump.
	if Input.is_action_just_pressed("move_jump(space)") and can_jump == true:
		velocity.y = -JUMP_VELOCITY
		can_jump = false

	var direction := Input.get_axis("move_left(a)", "move_right(d)")
	if direction:
		velocity.x += ACCELERATION * direction * delta
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	if velocity.x > 0:
		animation_player.speed_scale = absf(velocity.x) / (MAX_SPEED * 1 / ANIMATION_SPEED_MULTIPLIER)
		animation_player.play("run")
		sprite_group.scale.x = -original_scale_x
	elif velocity.x < 0:
		animation_player.speed_scale = absf(velocity.x) / (MAX_SPEED * 1 / ANIMATION_SPEED_MULTIPLIER)
		animation_player.play("run")
		sprite_group.scale.x = original_scale_x
	else:
		animation_player.play("idle")
	move_and_slide()

func _on_timer_timeout() -> void:
	can_jump = false
