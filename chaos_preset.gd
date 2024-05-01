class_name ChaosPreset extends Resource

## Name of this particular preset.
@export var name: String = "New ChaosPreset"

## Canvas size. It's always a square.
@export var canvas_size: int = 1024

## How many iterations should the chaos game run for
@export var iterations: int = 100_000

## How far to a vertex should the chaos game go. Typically below 1, but can also go higher.
@export var ratio: float = 0.5

## Vertices on the canvas. Format: [0, 0] is topleft and [1,1] bottom right.
@export var points: Array[Vector2] = []

## Canvas color
@export var background_color: Color = Color.WHITE
