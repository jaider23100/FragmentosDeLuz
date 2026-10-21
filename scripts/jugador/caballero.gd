class_name Caballero
extends CharacterBody2D
## Personaje jugable (Sir Aldric): movimiento, salto, doble salto, dash, ataque con espada y daño.
##
## El comportamiento se organiza con una máquina de estados (enum [enum Estado]).

enum Estado { QUIETO, CORRIENDO, SALTANDO, CAYENDO, DOBLE_SALTO, DASH, ATACANDO, HERIDO, MUERTO }

const ANIMACIONES: Dictionary = {
	Estado.QUIETO: "quieto", Estado.CORRIENDO: "caminar", Estado.SALTANDO: "saltar",
	Estado.CAYENDO: "caer", Estado.DOBLE_SALTO: "doble_salto", Estado.DASH: "dash",
	Estado.ATACANDO: "atacar", Estado.HERIDO: "herido", Estado.MUERTO: "muerto",
}
## Distancia horizontal del área de la espada al centro del caballero, en px.
const ALCANCE_ESPADA_X: float = 10.0
## Intervalo del parpadeo durante la invulnerabilidad, en segundos.
const INTERVALO_PARPADEO: float = 0.1
## Velocidad máxima de subida dentro de una corriente de viento, en px/s (RF-10).
const VELOCIDAD_MAXIMA_VIENTO: float = 120.0

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
## Tiempo que el área de la espada permanece activa, en segundos (RF-04).
@export var duracion_ataque: float = 0.25
## Tiempo mínimo entre el inicio de dos ataques, en segundos (RF-04).
@export var enfriamiento_ataque: float = 0.35
## Velocidad del retroceso al recibir daño, en px/s (RF-05).
@export var empuje_herido: Vector2 = Vector2(120.0, -150.0)
## Duración del estado HERIDO (retroceso), en segundos (RF-05).
@export var duracion_herido: float = 0.3

var estado: Estado = Estado.QUIETO
var saltos_aereos_restantes: int = 1
var puede_dash: bool = true
## 1 si mira a la derecha, -1 si mira a la izquierda.
var direccion: int = 1
## Fuerza hacia arriba que aplica una corriente de viento, en px/s².
var fuerza_viento: float = 0.0
## Dirección en que el jugador intenta moverse (-1 a 1); la usa la roca para saber si la empujan.
var intencion_x: float = 0.0

var _dash_usado_en_aire: bool = false
var _enfriamiento_ataque_restante: float = 0.0
var _enemigos_golpeados: Array[Node2D] = []
var _tiempo_parpadeo: float = 0.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _area_espada: Area2D = $AreaEspada
@onready var _timer_dash: Timer = $TimerDash
@onready var _timer_enfriamiento_dash: Timer = $TimerEnfriamientoDash
@onready var _timer_ataque: Timer = $TimerAtaque
@onready var _timer_herido: Timer = $TimerHerido


func _ready() -> void:
	saltos_aereos_restantes = max_saltos_aereos
	_area_espada.monitoring = false
	_sprite.play(ANIMACIONES[estado])


func _process(delta: float) -> void:
	_actualizar_parpadeo(delta)


func _physics_process(delta: float) -> void:
	_enfriamiento_ataque_restante = maxf(_enfriamiento_ataque_restante - delta, 0.0)
	match estado:
		Estado.MUERTO:
			velocity = Vector2.ZERO
		Estado.DASH:
			velocity = Vector2(direccion * velocidad_dash, 0.0)
		Estado.HERIDO:
			velocity.y += gravedad * delta
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
	_terminar_ataque()
	puede_dash = false
	cambiar_estado(Estado.DASH)
	_timer_dash.start(duracion_dash)
	return true


## Golpe de espada hacia donde mira el caballero. Devuelve true si se ejecutó (RF-04).
func atacar() -> bool:
	if _enfriamiento_ataque_restante > 0.0 or not _puede_actuar() or estado == Estado.DASH:
		return false
	_enfriamiento_ataque_restante = enfriamiento_ataque
	_enemigos_golpeados.clear()
	_area_espada.position.x = direccion * ALCANCE_ESPADA_X
	_area_espada.set_deferred("monitoring", true)
	cambiar_estado(Estado.ATACANDO)
	_timer_ataque.start(duracion_ataque)
	return true


## Aplica el daño de un enemigo o peligro (RN-01, RN-02): retrocede o muere.
func recibir_dano() -> void:
	if estado == Estado.MUERTO:
		return
	if not EstadoJuego.recibir_dano():
		return
	_terminar_ataque()
	if EstadoJuego.corazones == 0:
		cambiar_estado(Estado.MUERTO)
		return
	velocity = Vector2(-direccion * empuje_herido.x, empuje_herido.y)
	cambiar_estado(Estado.HERIDO)
	_timer_herido.start(duracion_herido)


## Lleva al caballero a [param pos] detenido (reaparición en checkpoint o inicio).
func reaparecer(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
	_terminar_ataque()
	cambiar_estado(Estado.QUIETO)


## La corriente de viento empuja hacia arriba con [param fuerza] px/s² (RF-10).
func aplicar_viento(fuerza: float) -> void:
	fuerza_viento = fuerza


## Quita el efecto de la corriente de viento (RF-10).
func quitar_viento() -> void:
	fuerza_viento = 0.0


## Cambia el estado actual de la máquina de estados y su animación.
func cambiar_estado(nuevo: Estado) -> void:
	if estado == nuevo:
		return
	estado = nuevo
	if is_node_ready():
		_sprite.play(ANIMACIONES[estado])


func _procesar_movimiento(delta: float) -> void:
	var eje: float = Input.get_axis("mover_izquierda", "mover_derecha")
	intencion_x = eje
	if eje != 0.0 and estado != Estado.ATACANDO:
		direccion = 1 if eje > 0.0 else -1
		_sprite.flip_h = direccion < 0
	velocity.x = eje * velocidad
	if not is_on_floor() or fuerza_viento > 0.0:
		velocity.y += (gravedad - fuerza_viento) * delta
	if fuerza_viento > 0.0:
		velocity.y = maxf(velocity.y, -VELOCIDAD_MAXIMA_VIENTO)
	if Input.is_action_just_pressed("saltar"):
		if is_on_floor():
			saltar()
		else:
			doble_salto()
	elif Input.is_action_just_released("saltar") and velocity.y < 0.0:
		velocity.y *= 0.5
	if Input.is_action_just_pressed("dash"):
		dash()
	if Input.is_action_just_pressed("atacar"):
		atacar()


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


func _actualizar_parpadeo(delta: float) -> void:
	if estado == Estado.MUERTO or not EstadoJuego.esta_invulnerable():
		_sprite.visible = true
		_tiempo_parpadeo = 0.0
		return
	_tiempo_parpadeo += delta
	_sprite.visible = int(_tiempo_parpadeo / INTERVALO_PARPADEO) % 2 == 0


func _puede_actuar() -> bool:
	return estado not in [Estado.HERIDO, Estado.MUERTO]


func _terminar_ataque() -> void:
	_area_espada.set_deferred("monitoring", false)
	_timer_ataque.stop()


func _estado_tras_accion() -> Estado:
	return Estado.QUIETO if is_on_floor() else Estado.CAYENDO


func _on_timer_dash_timeout() -> void:
	if estado != Estado.DASH:
		return
	velocity.x = 0.0
	cambiar_estado(_estado_tras_accion())
	_timer_enfriamiento_dash.start(enfriamiento_dash)


func _on_timer_enfriamiento_dash_timeout() -> void:
	puede_dash = true


func _on_timer_ataque_timeout() -> void:
	_terminar_ataque()
	if estado == Estado.ATACANDO:
		cambiar_estado(_estado_tras_accion())


func _on_timer_herido_timeout() -> void:
	if estado == Estado.HERIDO:
		cambiar_estado(_estado_tras_accion())


func _on_area_espada_body_entered(body: Node2D) -> void:
	if body is Enemigo and body not in _enemigos_golpeados:
		_enemigos_golpeados.append(body)
		(body as Enemigo).recibir_golpe()
