class_name ChaosPreset extends Resource

## Name of this particular preset.
@export var name: String = "New ChaosPreset"

@export var canvas_size: int = 1024

## How far to a vertex should the chaos game go. Typically below 1, but can also go higher.
@export var ratio: float = 0.5

## Vertices on the canvas. Format: [-1,-1] is topleft and [1,1] bottom right. [0,0] is right in the 
## middle of the chaos game image.
@export var points: Array[Vector2] = []


@export var background_color: Color = Color.WHITE
