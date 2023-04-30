extends CanvasLayer

var destination: Node2D

func translate_to_inner(pos: Vector2, rect: Rect2) -> Vector2:
	var c := rect.get_center()
	var ctop := pos - c
	if abs(ctop.y) < 0.01:
		if pos.y <= 0:
			return Vector2(c.x, 0)
		else:
			return Vector2(c.x, rect.end.y)
	if abs(ctop.x) < 0.01:
		if pos.x <= 0:
			return Vector2(0, c.y)
		else:
			return Vector2(rect.end.x, c.y)
	var ctopxy := c.y * ctop.x / ctop.y
	var toprx := c.x - ctopxy
	if toprx >= 0 and toprx <= rect.end.x:
		if ctop.y <= 0:
			return Vector2(toprx, 0)
		return Vector2(c.x + ctopxy, rect.end.y)
	var ctopyx := c.x * ctop.y / ctop.x
	if ctop.x <= 0:
		return Vector2(0, c.y - ctopyx)
	return Vector2(rect.end.x, c.y + ctopyx)

func _process(_delta: float) -> void:
	if not is_instance_valid(destination):
		return
	var rect := get_viewport().get_visible_rect()
	rect.size -= Vector2(8, 8)
	var pos := destination.get_canvas_transform() * destination.position
	if not rect.has_point(pos):
		pos = translate_to_inner(pos, rect)

	$Texture.position = pos
	$Texture.rotation = Vector2(0, -1).angle_to(pos - rect.get_center())

	$TimeLabel.position = pos - Vector2(0, $Texture.size.y * 1.2)
	if $TimeLabel.position.x + $TimeLabel.size.x > rect.end.x - $Texture.size.x:
		$TimeLabel.position.x = rect.end.x - $TimeLabel.size.x
	if $TimeLabel.position.y < $Texture.size.y:
		$TimeLabel.position.y = $Texture.size.y
