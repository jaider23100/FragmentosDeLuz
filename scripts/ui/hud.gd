class_name Hud
extends CanvasLayer
## HUD del nivel: corazones, fragmentos y puntaje, más mensajes y textos de carteles (RF-14).
##
## Escucha las señales de EstadoJuego (patrón Observador); nunca consulta el estado en cada cuadro.

## Segundos que dura un mensaje en pantalla (por ejemplo, "Faltan 2 fragmentos").
const DURACION_MENSAJE: float = 2.0
## Escala del contador de fragmentos durante su animación al recoger uno.
const ESCALA_PULSO: Vector2 = Vector2(1.4, 1.4)

var _textura_llena: AtlasTexture
var _textura_vacia: AtlasTexture

@onready var _corazones: Array[TextureRect] = [%Corazon1, %Corazon2, %Corazon3]
@onready var _etiqueta_fragmentos: Label = %EtiquetaFragmentos
@onready var _etiqueta_puntos: Label = %EtiquetaPuntos
@onready var _mensaje: Label = %Mensaje
@onready var _texto_cartel: PanelContainer = %TextoCartel
@onready var _etiqueta_cartel: Label = %EtiquetaCartel
@onready var _timer_mensaje: Timer = $TimerMensaje


func _ready() -> void:
	add_to_group("hud")
	_textura_llena = _corazones[0].texture as AtlasTexture
	_textura_vacia = _textura_llena.duplicate() as AtlasTexture
	_textura_vacia.region.position.x = 8.0
	EstadoJuego.corazones_cambiados.connect(_on_corazones_cambiados)
	EstadoJuego.fragmentos_cambiados.connect(_on_fragmentos_cambiados)
	EstadoJuego.puntos_cambiados.connect(_on_puntos_cambiados)
	_on_corazones_cambiados(EstadoJuego.corazones)
	_on_fragmentos_cambiados(EstadoJuego.fragmentos, false)
	_on_puntos_cambiados(EstadoJuego.puntos)
	_mensaje.visible = false
	_texto_cartel.visible = false


## Muestra [param texto] en el centro de la pantalla durante [constant DURACION_MENSAJE] segundos.
func mostrar_mensaje(texto: String) -> void:
	_mensaje.text = texto
	_mensaje.visible = true
	_timer_mensaje.start(DURACION_MENSAJE)


## Muestra el texto de un cartel de piedra en la parte inferior.
func mostrar_texto_cartel(texto: String) -> void:
	_etiqueta_cartel.text = texto
	_texto_cartel.visible = true


## Oculta el texto del cartel.
func ocultar_texto_cartel() -> void:
	_texto_cartel.visible = false


func _on_corazones_cambiados(corazones: int) -> void:
	for i: int in _corazones.size():
		_corazones[i].texture = _textura_llena if i < corazones else _textura_vacia


func _on_fragmentos_cambiados(fragmentos: int, animar: bool = true) -> void:
	_etiqueta_fragmentos.text = "%d/%d" % [fragmentos, EstadoJuego.TOTAL_FRAGMENTOS]
	if animar and fragmentos > 0:
		_etiqueta_fragmentos.pivot_offset = _etiqueta_fragmentos.size / 2.0
		var animacion: Tween = create_tween()
		animacion.tween_property(_etiqueta_fragmentos, "scale", ESCALA_PULSO, 0.1)
		animacion.tween_property(_etiqueta_fragmentos, "scale", Vector2.ONE, 0.15)


func _on_puntos_cambiados(puntos: int) -> void:
	_etiqueta_puntos.text = "%d pts" % puntos


func _on_timer_mensaje_timeout() -> void:
	_mensaje.visible = false
