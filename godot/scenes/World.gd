extends Node2D

const Package = preload("res://scenes/Package.tscn")
const Ufo = preload("res://scenes/Ufo.tscn")
const Destination = preload("res://scenes/Destination.tscn")
const FatAlien = preload("res://scenes/aliens/FatAlien.tscn")
const FixedAlien = preload("res://scenes/aliens/FixedAlien.tscn")
const BlueArrow = preload("res://scenes/UI/BlueArrow.tscn")

const PACKAGE_SPAWN_RATE := 20.0
const PACKAGE_SPAWN_OFFSET := 5.0
const PACKAGE_TIMEOUT := 60.0

@export var UFO_SPAWN_CHANCE = 0.5

var package_spawn_areas: Array[Vector2] = []
var package_destination_areas: Array[Node2D] = []
var walkable_street_tiles: Array[Vector2i] = []
var _astar = AStarGrid2D.new()

func populate_walkable_street_tiles():
	var gtm: TileMap = $GroundTileMap
	var otm: TileMap = $ObjectTileMap
	var grect := gtm.get_used_rect()
	var orect := otm.get_used_rect()
	var eend := Vector2i(max(grect.end.x, orect.end.x), max(grect.end.y, orect.end.y))
	_astar.size = eend
	_astar.cell_size = gtm.tile_set.tile_size
	_astar.offset = _astar.cell_size * 0.5
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	_astar.update()
	for dy in range(0, eend.y):
		for dx in range(0, eend.x):
			var xy := Vector2i(dx, dy)
			var b := gtm.get_cell_source_id(0, xy) >= 0 and otm.get_cell_source_id(0, xy) < 0
			if b:
				walkable_street_tiles.append(xy)
			_astar.set_point_solid(xy, not b)

class TileLocation:
	var source_id: int
	var atlas_pos: Vector2i
	var center_offset: Vector2

	func _init(my_source_id: int, my_atlas_pos: Vector2i, my_center_offset: Vector2):
		self.source_id = my_source_id
		self.atlas_pos = my_atlas_pos
		self.center_offset = my_center_offset

func _ready():
	# initialize WORLD_BOUNDARY
	var boundary = get_tree().get_first_node_in_group("Boundary")
	Globals.WORLD_BOUNDARY = Rect2(boundary.position, boundary.size)

	package_spawn_areas = populate_areas("canPackagesSpawn")
	for pos in populate_areas("canBeDestination"):
		var dest := Destination.instantiate()
		add_child(dest)
		dest.position = pos
		dest.collectible = Globals.get_random_collectible() # TODO this should be decided by another custom data layer
		package_destination_areas.append(dest)
	start_package_spawn_timer(true)

	populate_walkable_street_tiles()
	# _init_astar()
	var alien = FatAlien.instantiate()
	alien.position = _astar.get_point_position(Vector2i(14, 17))
	# add_child(alien)
	var fixed_alien = FixedAlien.instantiate()
	fixed_alien.position = _astar.get_point_position(Vector2i(18, 3))
	# add_child(fixed_alien)

func get_areas(layer_name: String) -> Array[TileLocation]:
	var ts: TileSet = $ObjectTileMap.tile_set
	var tile_locs: Array[TileLocation] = []
	for ix in range(ts.get_source_count()):
		var sid := ts.get_source_id(ix)
		var source: TileSetAtlasSource = ts.get_source(sid)
		for tix in range(source.get_tiles_count()):
			var xy := source.get_tile_id(tix)
			var data := source.get_tile_data(xy, 0)
			if data.get_custom_data(layer_name):
				tile_locs.append(TileLocation.new(sid, xy, Vector2(-data.texture_origin)))
	return tile_locs

func populate_areas(layer_name: String):
	var map: TileMap = $ObjectTileMap
	var locs := get_areas(layer_name)
	var areas: Array[Vector2] = []
	for loc in locs:
		for area in map.get_used_cells_by_id(0, loc.source_id, loc.atlas_pos):
			areas.append(map.map_to_local(area) + loc.center_offset)
	return areas

func start_package_spawn_timer(initial := false):
	var time: float
	if initial:
		time = randf_range(0, PACKAGE_SPAWN_OFFSET)
	else:
		time = randf_range(PACKAGE_SPAWN_RATE - PACKAGE_SPAWN_OFFSET, PACKAGE_SPAWN_RATE + PACKAGE_SPAWN_OFFSET)
	$PackageSpawnTimer.start(time)

func spawn_package():
	# create a new package
	var package: Node2D = Package.instantiate()
	add_child(package)

	# select spawn position
	assert(not package_spawn_areas.is_empty())
	var spawn_idx := randi_range(0, len(package_spawn_areas) - 1)
	package.position = package_spawn_areas[spawn_idx]

	# select destination
	assert(not package_destination_areas.is_empty())
	var dest_idx := randi_range(0, len(package_destination_areas) - 1)
	package.destination = package_destination_areas[dest_idx]

	var arrow := BlueArrow.instantiate()
	arrow.destination = package
	$UI.add_child(arrow)
	package.blue_arrow = arrow

	package.collectible = Globals.get_random_collectible()
	package.start_timer(0.0, PACKAGE_TIMEOUT, $Jeff._on_package_timeout.bind(package))
	return package

func _on_package_spawn_timer_timeout():
	spawn_package()
	start_package_spawn_timer()

func _on_ufo_timer_timeout():
	if randf_range(0, 1) <= UFO_SPAWN_CHANCE:
		add_child(Ufo.instantiate())
