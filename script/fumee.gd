extends AnimatedSprite2D

func _on_area_2d_body_entered(_body: Node2D) -> void:
	ManagerPlayer.hp = ManagerPlayer.hp -1
	$audio_toux.play()
