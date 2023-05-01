extends CanvasLayer

var destination: Node2D
var progress_bar: Node2D

const DESTINATION_MARGIN := 13
const LEFT_CLIP := 7.0

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
	var margin = progress_bar.radius_outer + 5.0
	rect.size -= Vector2(margin, margin)
	var pos: Vector2 = destination.get_canvas_transform() * (destination.position - 0.5 * $Texture.size)
	var dir := rect.get_center().direction_to(pos)

	if not rect.has_point(pos):
		pos = translate_to_inner(pos, rect)
	else:
		pos -= DESTINATION_MARGIN * dir

	if pos.x < LEFT_CLIP:
		pos.x = LEFT_CLIP
	if pos.y < LEFT_CLIP:
		pos.y = LEFT_CLIP

	$Texture.position = pos
	$Texture.rotation = Vector2(0, -1).angle_to(dir)
	
	progress_bar.position = pos + 0.5 * $Texture.size
