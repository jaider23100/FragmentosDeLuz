class_name Caballero
extends CharacterBody2D
## Personaje jugable (Sir Aldric): movimiento, salto, doble salto y dash.
##
## El comportamiento se organiza con una máquina de estados (enum [enum Estado]).

enum Estado { QUIETO, CORRIENDO, SALTANDO, CAYENDO, DOBLE_SALTO, DASH, ATACANDO, HERIDO, MUERTO }

## Velocidad horizontal al caminar, en px/s (RF-01).
@export var velocidad: float = 100.0
## Velocidad vertical inicial del salto desde el suelo, en px/s (RF-01).
@export var velocidad_salto: float = 260.0
## Gravedad aplicada al caballero en el aire, en px/s².
@export var gravedad: float = 800.0
## Velocidad vertical del doble salto, en px/s (RF-02).
@export var velocidad_doble_salto: float = 220.0
## Saltos permitidos en el aire antes de tocar el suelo (RF-02).
@export var max_saltos_aereos: int = 1
## Velocidad horizontal durante el dash, en px/s (RF-03).
@export var velocidad_dash: float = 260.0
## Duración del dash, en segundos (RF-03).
@export var duracion_dash: float = 0.15
## Tiempo de espera entre dos dash, en segundos (RF-03).
@export var enfriamiento_dash: float = 0.5

var estado: Estado = Estado.QUIETO
var saltos_aereos_restantes: int = 1
var puede_dash: bool = true
## 1 si mira a la derecha, -1 si mira a la izquierda.
var direccion: int = 1
## Fuerza hacia arriba que aplica una corriente de viento, en px/s².
var fuerza_viento: float = 0.0

var _dash_usado_en_aire: bool = false

@onready var _timer_dash: Timer = $TimerDash
@onready var _timer_enfriamiento_dash: Timer = $TimerEnfriamientoDash


func _ready() -> void:
	saltos_aereos_restantes = max_saltos_aereos


func _physics_process(delta: float) -> void:
	match estado:
		Estado.MUERTO:
			velocity = Vector2.ZERO
		Estado.DASH:
			velocity = Vector2(direccion * velocidad_dash, 0.0)
		_:
			_procesar_movimiento(delta)
	move_and_slide()
	_actualizar_estado_por_fisica()


## Salta desde el suelo. Devuelve true si se ejecutó (RF-01).
func saltar() -> bool:
	if not is_on_floor() or not _puede_actuar():
		return false
	velocity.y = -velocidad_salto
	cambiar_estado(Estado.SALTANDO)
	return true


## Segundo salto en el aire, una vez por salto. Devuelve true si se ejecutó (RF-02).
func doble_salto() -> bool:
	if is_on_floor() or saltos_aereos_restantes <= 0 or not _puede_actuar():
		return false
	velocity.y = -velocidad_doble_salto
	saltos_aereos_restantes -= 1
	cambiar_estado(Estado.DOBLE_SALTO)
	return true


## Impulso horizontal sin gravedad; en el aire, uno por salto. Devuelve true si se ejecutó (RF-03).
func dash() -> bool:
	if not puede_dash or not _puede_actuar():
		return false
	if not is_on_floor():
		if _dash_usado_en_aire:
			return false
		_dash_usado_en_aire = true
	puede_dash = false
	cambiar_estado(Estado.DASH)
	_timer_dash.start(duracion_dash)
	return true


## Aplica el daño de un enemigo o peligro a través de EstadoJuego (RN-01, RN-02).
func recibir_dano() -> void:
	if estado == Estado.MUERTO:
		return
	if EstadoJuego.recibir_dano() and EstadoJuego.corazones == 0:
		cambiar_estado(Estado.MUERTO)


## Lleva al caballero a [param pos] detenido (reaparición en checkpoint o inicio).
func reaparecer(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
	cambiar_estado(Estado.QUIETO)


## La corriente de viento empuja hacia arriba con [param fuerza] px/s² (RF-10).
func aplicar_viento(fuerza: float) -> void:
	fuerza_viento = fuerza


## Quita el efecto de la corriente de viento (RF-10).
func quitar_viento() -> void:
	fuerza_viento = 0.0


## Cambia el estado actual de la máquina de estados.
func cambiar_estado(nuevo: Estado) -> void:
	if estado == nuevo:
		return
	estado = nuevo


func _procesar_movimiento(delta: float) -> void:
	var eje: float = Input.get_axis("mover_izquierda", "mover_derecha")
	if eje != 0.0:
		direccion = 1 if eje > 0.0 else -1
	velocity.x = eje * velocidad
	if not is_on_floor():
		velocity.y += (gravedad - fuerza_viento) * delta
	if Input.is_action_just_pressed("saltar"):
		if is_on_floor():
			saltar()
		else:
			doble_salto()
	elif Input.is_action_just_released("saltar") and velocity.y < 0.0:
		velocity.y *= 0.5
	if Input.is_action_just_pressed("dash"):
		dash()


func _actualizar_estado_por_fisica() -> void:
	if is_on_floor():
		saltos_aereos_restantes = max_saltos_aereos
		_dash_usado_en_aire = false
	if estado in [Estado.DASH, Estado.ATACANDO, Estado.HERIDO, Estado.MUERTO]:
		return
	if is_on_floor():
		cambiar_estado(Estado.CORRIENDO if absf(velocity.x) > 0.0 else Estado.QUIETO)
	elif velocity.y > 0.0:
		cambiar_estado(Estado.CAYENDO)


func _puede_actuar() -> bool:
	return estado not in [Estado.HERIDO, Estado.MUERTO]


func _on_timer_dash_timeout() -> void:
	if estado != Estado.DASH:
		return
	velocity.x = 0.0
	cambiar_estado(Estado.QUIETO if is_on_floor() else Estado.CAYENDO)
	_timer_enfriamiento_dash.start(enfriamiento_dash)


func _on_timer_enfriamiento_dash_timeout() -> void:
	puede_dash = true
