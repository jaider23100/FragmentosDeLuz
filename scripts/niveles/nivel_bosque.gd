class_name NivelBosque
extends Node2D
## Nivel del Bosque Marchito: inicia la partida, controla la caída al vacío y la reaparición.

## Segundos de espera antes de cambiar a la pantalla de derrota o al final.
const PAUSA_ANTES_DE_PANTALLA: float = 1.2

## Coordenada Y a partir de la cual el caballero cayó al vacío, en px.
@export var limite_caida_y: float = 520.0
## Zona visible del nivel; la cámara del caballero no sale de este rectángulo, en px.
@export var limites_camara: Rect2i = Rect2i(0, 0, 3840, 440)

var posicion_inicio: Vector2 = Vector2.ZERO

@onready var _caballero: Caballero = $Caballero
@onready var _marcador_inicio: Marker2D = $PosicionInicio
@onready var _camara: Camera2D = $Caballero/Camera2D


func _ready() -> void:
	posicion_inicio = _marcador_inicio.global_position
	_camara.limit_left = limites_camara.position.x
	_camara.limit_top = limites_camara.position.y
	_camara.limit_right = limites_camara.end.x
	_camara.limit_bottom = limites_camara.end.y
	EstadoJuego.reiniciar()
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.JUGANDO)
	EstadoJuego.jugador_murio.connect(_on_jugador_murio)
	EstadoJuego.nivel_completado.connect(_on_nivel_completado)
	_caballero.reaparecer(posicion_inicio)


func _physics_process(_delta: float) -> void:
	_comprobar_caida()


## Si el caballero cae al vacío pierde 1 corazón y reaparece en el último checkpoint (RN-03).
func _comprobar_caida() -> void:
	if _caballero.estado == Caballero.Estado.MUERTO:
		return
	if _caballero.global_position.y <= limite_caida_y:
		return
	EstadoJuego.recibir_dano(true)
	if EstadoJuego.corazones > 0:
		_caballero.reaparecer(EstadoJuego.obtener_punto_reaparicion(posicion_inicio))
	else:
		_caballero.cambiar_estado(Caballero.Estado.MUERTO)


## Derrota (RN-07): deja ver la animación de muerte y abre la pantalla de derrota.
func _on_jugador_murio() -> void:
	await get_tree().create_timer(PAUSA_ANTES_DE_PANTALLA).timeout
	GestorEscenas.cambiar_escena(GestorEscenas.DERROTA)


## Victoria (RN-06, RN-08): abre la cinemática final.
func _on_nivel_completado(_puntaje_final: int) -> void:
	await get_tree().create_timer(PAUSA_ANTES_DE_PANTALLA).timeout
	GestorEscenas.cambiar_escena(GestorEscenas.FINAL)
