extends Node2D

const Package = preload("res://scenes/Package.tscn")
const Ufo = preload("res://scenes/Ufo.tscn")
const Destination = preload("res://scenes/Destination.tscn")
const FatAlien = preload("res://scenes/aliens/FatAlien.tscn")

const PACKAGE_SPAWN_RATE := 6.0
const PACKAGE_SPAWN_OFFSET := 3.0

@export var ufo_spawn_chance = 1.0

var package_spawn_areas: Array[Vector2] = []
var package_destination_areas: Array[Node2D] = []
var _astar = AStarGrid2D.new()

class TileLocation:
	var source_id: int
	var atlas_pos: Vector2i

	func _init(my_source_id: int, my_atlas_pos: Vector2i):
		self.source_id = my_source_id
		self.atlas_pos = my_atlas_pos

func _ready():
	package_spawn_areas = populate_areas("canPackagesSpawn")
	for pos in populate_areas("canBeDestination"):
		var dest := Destination.instantiate()
		add_child(dest)
		dest.position = pos
		package_destination_areas.append(dest)
	start_package_spawn_timer()
	_init_astar()
	var alien = FatAlien.instantiate()
	alien.position = _astar.get_point_position(Vector2i(2, 10))
	add_child(alien)
	

func _init_astar():
	var tm: TileMap = $ObjectTileMap
	_astar.size = tm.get_used_rect().end
	_astar.cell_size = tm.tile_set.tile_size
	_astar.update()
	for cell in tm.get_used_cells(0):
		print("cell: ", cell)
		_astar.set_point_solid(cell, true)

func vector_to_grid(v: Vector2):
	return (v/_astar.cell_size).floor()

func get_areas(layer_name: String) -> Array[TileLocation]:
	var ts: TileSet = $ObjectTileMap.tile_set
	var tile_locs: Array[TileLocation] = []
	for ix in range(ts.get_source_count()):
		var sid := ts.get_source_id(ix)
		var source: TileSetAtlasSource = ts.get_source(sid)
		for tix in range(source.get_tiles_count()):
			var xy := source.get_tile_id(tix)
			var data = source.get_tile_data(xy, 0)
			if data.get_custom_data(layer_name):
				tile_locs.append(TileLocation.new(sid, xy))
	return tile_locs

func populate_areas(layer_name: String):
	var map: TileMap = get_node('ObjectTileMap')
	var locs := get_areas(layer_name)
	var areas: Array[Vector2] = []
	for loc in locs:
		for area in map.get_used_cells_by_id(0, loc.source_id, loc.atlas_pos):
			areas.append(map.map_to_local(area))
	return areas

func start_package_spawn_timer():
	var time := randf_range(PACKAGE_SPAWN_RATE - PACKAGE_SPAWN_OFFSET, PACKAGE_SPAWN_RATE + PACKAGE_SPAWN_OFFSET)
	$PackageSpawnTimer.start(time)

func spawn_package():
	# create a new package
	var package: Node2D = Package.instantiate()
	add_child(package)

	# select spawn position
	var spawn_idx := randi_range(0, len(package_spawn_areas) - 1)
	package.position = package_spawn_areas[spawn_idx]

	# select destination
	var dest_idx := randi_range(0, len(package_destination_areas) - 1)
	package.destination = package_destination_areas[dest_idx]

	package.start_timer(20.0, $Jeff._on_package_timeout.bind(package))
	return package

func _on_package_spawn_timer_timeout():
	spawn_package()
	start_package_spawn_timer()

func _on_ufo_timer_timeout():
	if randf_range(0, 1) > ufo_spawn_chance:
		return

	add_child(Ufo.instantiate())
