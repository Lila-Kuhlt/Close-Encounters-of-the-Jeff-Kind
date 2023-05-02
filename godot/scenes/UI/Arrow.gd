extends CanvasLayer

var destination: Node2D
var progress_bar: Node2D

const DESTINATION_MARGIN := 13

func translate_to_inner(pos: Vector2, rect: Rect2) -> Vector2:
	var c := rect.get_center()
	var rect1 := rect.position
	var rect2 := rect.position + Vector2(rect.size.x, 0)
	var rect3 := rect.end
	var rect4 := rect.position + Vector2(0, rect.size.y)

	var x = Geometry2D.segment_intersects_segment(c, pos, rect1, rect2)
	if x != null: return x
	x = Geometry2D.segment_intersects_segment(c, pos, rect2, rect3)
	if x != null: return x
	x = Geometry2D.segment_intersects_segment(c, pos, rect3, rect4)
	if x != null: return x
	x = Geometry2D.segment_intersects_segment(c, pos, rect4, rect1)
	assert(x != null)
	return x

func _process(_delta: float) -> void:
	if not is_instance_valid(destination):
		return
	var rect := get_viewport().get_visible_rect()
	var margin = progress_bar.radius_outer + 2.0
	rect.position += Vector2(margin, margin)
	rect.size -= 2 * Vector2(margin, margin)
	var pos: Vector2 = destination.get_canvas_transform() * (destination.position - 0.5 * $Texture.size)
	var dir := rect.get_center().direction_to(pos)

	if not rect.has_point(pos):
		pos = translate_to_inner(pos, rect) - 0.5 * $Texture.size
	else:
		pos -= DESTINATION_MARGIN * dir

	$Texture.position = pos
	$Texture.rotation = Vector2(0, -1).angle_to(dir)

	progress_bar.position = pos + 0.5 * $Texture.size
