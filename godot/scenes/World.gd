extends Node2D

const Package = preload("res://scenes/Package.tscn")
const Ufo = preload("res://scenes/Ufo.tscn")

const PACKAGE_SPAWN_RATE := 6.0
const PACKAGE_SPAWN_OFFSET := 3.0

@export var ufo_spawn_chance = 0.5

var package_spawn_areas := []

class TileLocation:
	var source_id: int
	var atlas_pos: Vector2i

	func _init(my_source_id: int, my_atlas_pos: Vector2i):
		self.source_id = my_source_id
		self.atlas_pos = my_atlas_pos

func get_spawnable_areas() -> Array[TileLocation]:
	var ts: TileSet = $ObjectTileMap.tile_set
	var tile_locs: Array[TileLocation] = []
	for ix in range(ts.get_source_count()):
		var sid := ts.get_source_id(ix)
		var source: TileSetAtlasSource = ts.get_source(sid)
		for tix in range(source.get_tiles_count()):
			var xy := source.get_tile_id(tix)
			var data = source.get_tile_data(xy, 0)
			if data.get_custom_data('canPackagesSpawn'):
				tile_locs.append(TileLocation.new(sid, xy))
	return tile_locs

func _ready():
	populate_package_spawn_areas()

func populate_package_spawn_areas():
	var map: TileMap = get_node('ObjectTileMap')
	var locs := get_spawnable_areas()
	for loc in locs:
		var areas := map.get_used_cells_by_id(0, loc.source_id, loc.atlas_pos)
		for area in areas:
			package_spawn_areas.append(map.map_to_local(area))
	start_package_spawn_timer()

func start_package_spawn_timer():
	var time := randf_range(PACKAGE_SPAWN_RATE - PACKAGE_SPAWN_OFFSET, PACKAGE_SPAWN_RATE + PACKAGE_SPAWN_OFFSET)
	$PackageSpawnTimer.start(time)

func spawn_package():
	var package: Node2D = Package.instantiate()
	add_child(package)
	var idx := randi_range(0, len(package_spawn_areas) - 1)
	package.position = package_spawn_areas[idx]
	package.start_timer(20.0, $Jeff._on_package_timeout.bind(package))
	return package

func _on_package_spawn_timer_timeout():
	spawn_package()
	start_package_spawn_timer()

func _on_ufo_timer_timeout():
	if randf_range(0, 1) > ufo_spawn_chance:
		return

	add_child(Ufo.instantiate())
