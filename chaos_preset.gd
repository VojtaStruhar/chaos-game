class_name ChaosPreset extends Resource

## Name of this particular preset.
@export var name: String = "New ChaosPreset"

## Canvas size. It's always a square.
@export_range(1024, 4096, 512) var canvas_size: int = 1024

## How many iterations should the chaos game run for
@export_range(5_000, 1_000_000, 5_000) var iterations: int = 100_000

## How far to a vertex should the chaos game go. Typically below 1, but can also go higher.
@export_range(0.001, 2, 0.001) var ratio: float = 0.5

## Vertices on the canvas. Format: [0, 0] is topleft and [1,1] bottom right.
@export var points: Array[Vector2] = []

## If adding new points is allowed
@export var can_add_points: bool = true

## If moving points is allowed
@export var can_move_points: bool = true

## Canvas color
@export var background_color: Color = Color.WHITE

## Show helper "handles" on vertices
@export var show_vertices: bool = true

## Outline the vertices with a line. Order of the vertices starts to matter here!
@export var show_helper_line: bool = true
