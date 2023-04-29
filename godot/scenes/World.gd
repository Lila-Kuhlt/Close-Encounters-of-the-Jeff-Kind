extends Node2D

const Package = preload("res://scenes/Package.tscn")
const Ufo = preload("res://scenes/Ufo.tscn")

@export var ufo_spawn_chance = 0.5

var rng := RandomNumberGenerator.new()
var package_spawn_areas := []

class TileLocation:
	var source_id: int
	var atlas_pos: Vector2i
	
	func _init(source_id: int, atlas_pos: Vector2i):
		self.source_id = source_id
		self.atlas_pos = atlas_pos

func get_spawnable_areas() -> Array[TileLocation]:
	var ts: TileSet = $ObjectTileMap.tile_set
	var tile_locs: Array[TileLocation] = []
	for ix in range(ts.get_source_count()):
		var sid := ts.get_source_id(ix)
		var source: TileSetAtlasSource = ts.get_source(sid)
		var gridsz: Vector2i = source.get_atlas_grid_size()
		for y in range(gridsz.y):
			for x in range(gridsz.x):
				var data = source.get_tile_data(Vector2i(x, y), 0)
				if data == null:
					continue
				if data.get_custom_data('canPackagesSpawn'):
					tile_locs.append(TileLocation.new(sid, Vector2i(x, y)))
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

func build_package():
	var package: Node2D = Package.instantiate()
	add_child(package)
	var idx := rng.randi_range(0, len(package_spawn_areas))
	package.position = package_spawn_areas[idx]
	package.start_timer(2.0, $Player._on_package_timeout.bind(package))
	return package


func _on_ufo_timer_timeout():
	if randf_range(0,1) > ufo_spawn_chance:
		return
	
	add_child(Ufo.instantiate())
