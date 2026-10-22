class_name Murcielago
extends Enemigo
## Murciélago de Sombra: duerme hasta que el caballero se acerca, lo persigue volando
## y regresa a su punto de origen si el caballero se aleja (RF-08).

enum Estado { DORMIDO, PERSIGUIENDO, REGRESANDO, MUERTO }

## Velocidad de vuelo, en px/s.
@export var velocidad: float = 60.0
## Distancia a la que despierta y empieza a perseguir, en px.
@export var radio_deteccion: float = 80.0
## Distancia a la que abandona la persecución, en px.
@export var radio_abandono: float = 140.0
## Distancia a su origen a la que se considera de vuelta, en px.
@export var tolerancia_origen: float = 3.0
## Duración del destello al recibir un golpe, en segundos.
@export var duracion_destello: float = 0.15

var estado: Estado = Estado.DORMIDO
var posicion_origen: Vector2 = Vector2.ZERO

var _caballero: Node2D = null

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	super()
	posicion_origen = global_position
	_sprite.play("dormido")


## Calcula el nuevo estado según la distancia al caballero y a su origen (DE-02).
func evaluar_estado(distancia_caballero: float, distancia_origen: float) -> Estado:
	match estado:
		Estado.DORMIDO:
			if distancia_caballero < radio_deteccion:
				return Estado.PERSIGUIENDO
		Estado.PERSIGUIENDO:
			if distancia_caballero > radio_abandono:
				return Estado.REGRESANDO
		Estado.REGRESANDO:
			if distancia_caballero < radio_deteccion:
				return Estado.PERSIGUIENDO
			if distancia_origen <= tolerancia_origen:
				return Estado.DORMIDO
	return estado


## Muere y deja de volar (RN-05).
func morir() -> void:
	estado = Estado.MUERTO
	super()


func _mover(delta: float) -> void:
	if estado == Estado.MUERTO:
		return
	if _caballero == null:
		_caballero = get_tree().get_first_node_in_group("jugador") as Node2D
	var distancia_caballero: float = INF if _caballero == null else global_position.distance_to(_caballero.global_position)
	_cambiar_estado(evaluar_estado(distancia_caballero, global_position.distance_to(posicion_origen)))
	match estado:
		Estado.PERSIGUIENDO:
			_perseguir(delta)
		Estado.REGRESANDO:
			_regresar(delta)
		_:
			velocity = Vector2.ZERO


func _perseguir(_delta: float) -> void:
	velocity = global_position.direction_to(_caballero.global_position) * velocidad
	_sprite.flip_h = velocity.x > 0.0
	move_and_slide()


func _regresar(_delta: float) -> void:
	velocity = global_position.direction_to(posicion_origen) * velocidad
	_sprite.flip_h = velocity.x > 0.0
	move_and_slide()


func _cambiar_estado(nuevo: Estado) -> void:
	if nuevo == estado:
		return
	estado = nuevo
	_sprite.play("dormido" if estado == Estado.DORMIDO else "volar")
	if estado == Estado.DORMIDO:
		global_position = posicion_origen


func _al_recibir_golpe() -> void:
	_sprite.modulate = Color(1.0, 0.4, 0.4)
	await get_tree().create_timer(duracion_destello).timeout
	if is_instance_valid(_sprite):
		_sprite.modulate = Color.WHITE
