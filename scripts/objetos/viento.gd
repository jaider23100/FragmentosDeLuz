class_name Viento
extends Area2D
## Corriente de viento (Area2D): mientras el caballero está dentro, lo empuja hacia arriba (RF-10).

## Fuerza hacia arriba que recibe el caballero, en px/s²; mayor que la gravedad (800) para que suba.
@export var fuerza: float = 1100.0
## Tamaño de la columna de viento, en px.
@export var tamano: Vector2 = Vector2(40.0, 220.0)

@onready var _forma: CollisionShape2D = $CollisionShape2D
@onready var _particulas: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	var rectangulo := RectangleShape2D.new()
	rectangulo.size = tamano
	_forma.shape = rectangulo
	_forma.position = Vector2(0.0, -tamano.y / 2.0)
	_particulas.position = Vector2(0.0, 0.0)
	_particulas.emission_rect_extents = Vector2(tamano.x / 2.0, 2.0)
	_particulas.lifetime = tamano.y / 90.0


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		(body as Caballero).aplicar_viento(fuerza)


func _on_body_exited(body: Node2D) -> void:
	if body is Caballero:
		(body as Caballero).quitar_viento()
