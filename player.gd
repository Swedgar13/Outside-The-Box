extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_group: Node2D = $"Sprite Group"
@onready var original_scale_x: float = sprite_group.scale.x

const MAX_SPEED = 300
const ACCELERATION = 400.0
const DECELERATION = 300.0
const JUMP_VELOCITY = 400.0
const ANIMATION_SPEED_MULTIPLIER = 1.2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump(space)") and is_on_floor():
		velocity.y = -JUMP_VELOCITY

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
