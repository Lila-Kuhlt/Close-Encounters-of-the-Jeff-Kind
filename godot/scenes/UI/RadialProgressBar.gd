@tool
extends Node2D

@export var radius_outer := 22: set = set_radius_outer
@export var radius_inner := 16: set = set_radius_inner
@export var color_background := Color(0.3, 0.3, 0.3, 0.8): set = set_color_background
@export var color_bar := Color(0.8, 0.1, 0.1, 1.0): set = set_color_bar

@export var value_max := 100.0: set = set_value_max
@export var value := 50.0: set = set_value

func set_radius_outer(v):
	radius_outer = v
	if is_inside_tree():
		$ColorRect.size = Vector2i(2 * radius_outer, 2 * radius_outer)
		$ColorRect.position = -Vector2i(radius_outer, radius_outer)
		_update_radii()
	
func set_radius_inner(v):
	radius_inner = v
	if is_inside_tree():
		$ColorRect.size = Vector2i(2 * radius_outer, 2 * radius_outer)
		$ColorRect.position = -Vector2i(radius_outer, radius_outer)
		_update_radii()

func set_color_background(v):
	color_background = v
	if is_inside_tree():
		get_shader_material().set_shader_parameter("color_background", color_background)

func set_color_bar(v):
	color_bar = v
	if is_inside_tree():
		get_shader_material().set_shader_parameter("color_bar", color_bar)
	
func set_value_max(v):
	value_max = v
	if is_inside_tree():
		_update_progress()
func set_value(v):
	value = v
	if is_inside_tree():
		_update_progress()

func _update_progress():
	get_shader_material().set_shader_parameter("progress", value / float(value_max))
func _update_radii():
	get_shader_material().set_shader_parameter("radius_inner", radius_inner / float(radius_outer))
	
func get_shader_material() -> ShaderMaterial:
	return $ColorRect.material

func _ready():
	set_radius_outer(radius_outer)
	set_radius_inner(radius_inner)
	set_color_background(color_background)
	set_color_bar(color_bar)
	set_value_max(value_max)
	set_value(value)
	
	if not Engine.is_editor_hint():
		$ColorRect.material = $ColorRect.material.duplicate()
