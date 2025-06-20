extends CharacterBody2D

const gravity = 1000
const UP = Vector2(0, -1)

var speed = 25
var dirx = 0
var dead = false

@onready var porc_epic_sprite = $AnimatedSprite2D

func _on_timer_timeout() -> void:
	var m = int(randf_range(0, 10))
	if dead == false:
		if m < 5:
			dirx = -1
		elif m > 5:
			dirx = 1
		else:
			dirx = 0

func _physics_process(_delta):
	if dead == false:
		velocity.x = 0
		velocity.y += gravity * _delta
		_movement_loop()
		move_and_slide()

func _movement_loop():
	if dead == false:
		var right = (dirx == 1)
		var left = (dirx == -1)
		if dirx == -1:
			velocity.x -= speed
		if dirx == 1:
			velocity.x += speed

		if is_on_wall():
			dirx += -1
		if right:
			porc_epic_sprite.flip_h = true
			porc_epic_sprite.play("walk")
		if left:
			porc_epic_sprite.flip_h = false
			porc_epic_sprite.play("walk")

func _on_killzone_body_entered(_body: Node2D) -> void:
	if _body is player:
		ManagerPlayer.hp = ManagerPlayer.hp -1
		if ManagerPlayer.hp < 1:
			_body._mort()
		elif ManagerPlayer.hp > 0:
			_body._ouch()

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_kickzone_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("frappe"):
		$AudioStreamPlayer.play()
		dead = true
		ManagerPlayer.points = ManagerPlayer.points + 100
		$death_timer.start()
		porc_epic_sprite.play("mort")

func _kill():
	ManagerPlayer.points = ManagerPlayer.points + 100
	queue_free()
