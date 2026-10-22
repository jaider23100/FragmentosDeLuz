extends Node
## Música y efectos de sonido del juego (autoload GestorAudio, RF-17).
##
## La música cambia sola según la fase de EstadoJuego (señal fase_cambiada) y baja durante la pausa.
## Todos los botones de la interfaz suenan al presionarlos sin que cada menú lo programe.

## Volumen inicial de los buses (0 a 1); GestorGuardado lo reemplaza cuando hay configuración guardada.
const VOLUMEN_POR_DEFECTO: float = 0.8
## Atenuación de la música mientras el juego está en pausa, en dB.
const ATENUACION_PAUSA_DB: float = -12.0
## Reproductores simultáneos de efectos.
const CANALES_EFECTOS: int = 6

const MUSICAS: Dictionary = {
	"menu": preload("res://assets/musica/musica_menu.mp3"),
	"nivel": preload("res://assets/musica/musica_nivel.mp3"),
}
const EFECTOS: Dictionary = {
	"salto": preload("res://assets/audio/salto.wav"),
	"doble_salto": preload("res://assets/audio/doble_salto.wav"),
	"dash": preload("res://assets/audio/dash.wav"),
	"espada": preload("res://assets/audio/espada.wav"),
	"golpe_enemigo": preload("res://assets/audio/golpe_enemigo.wav"),
	"dano": preload("res://assets/audio/dano.wav"),
	"fragmento": preload("res://assets/audio/fragmento.wav"),
	"moneda": preload("res://assets/audio/moneda.wav"),
	"checkpoint": preload("res://assets/audio/checkpoint.wav"),
	"victoria": preload("res://assets/audio/victoria.wav"),
	"derrota": preload("res://assets/audio/derrota.wav"),
	"boton": preload("res://assets/audio/boton.wav"),
}

var _pista_actual: String = ""
var _reproductor_musica: AudioStreamPlayer
var _efectos: Array[AudioStreamPlayer] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_reproductor_musica = AudioStreamPlayer.new()
	_reproductor_musica.bus = &"Musica"
	add_child(_reproductor_musica)
	for i: int in CANALES_EFECTOS:
		var canal := AudioStreamPlayer.new()
		canal.bus = &"Efectos"
		add_child(canal)
		_efectos.append(canal)
	aplicar_volumen("Musica", VOLUMEN_POR_DEFECTO)
	aplicar_volumen("Efectos", VOLUMEN_POR_DEFECTO)
	EstadoJuego.fase_cambiada.connect(_on_fase_cambiada)
	get_tree().node_added.connect(_on_nodo_agregado)
	reproducir_musica("menu")


## Reproduce en bucle la pista [param pista] ("menu" o "nivel"); no la reinicia si ya suena.
func reproducir_musica(pista: String) -> void:
	if pista == _pista_actual and _reproductor_musica.playing:
		return
	var flujo: AudioStream = MUSICAS[pista]
	if flujo is AudioStreamMP3:
		(flujo as AudioStreamMP3).loop = true
	_pista_actual = pista
	_reproductor_musica.stream = flujo
	_reproductor_musica.volume_db = 0.0
	_reproductor_musica.play()


## Reproduce el efecto [param nombre] en el primer canal libre.
func reproducir_efecto(nombre: String) -> void:
	if not EFECTOS.has(nombre):
		push_warning("Efecto de sonido desconocido: %s" % nombre)
		return
	for canal: AudioStreamPlayer in _efectos:
		if not canal.playing:
			canal.stream = EFECTOS[nombre]
			canal.play()
			return
	_efectos[0].stream = EFECTOS[nombre]
	_efectos[0].play()


## Aplica [param valor] (0 a 1) al bus [param bus]; con 0 lo silencia.
func aplicar_volumen(bus: String, valor: float) -> void:
	var indice: int = AudioServer.get_bus_index(bus)
	if indice < 0:
		return
	valor = clampf(valor, 0.0, 1.0)
	AudioServer.set_bus_volume_db(indice, linear_to_db(maxf(valor, 0.0001)))
	AudioServer.set_bus_mute(indice, valor == 0.0)


## Volumen actual del bus [param bus], de 0 a 1.
func obtener_volumen(bus: String) -> float:
	var indice: int = AudioServer.get_bus_index(bus)
	if indice < 0 or AudioServer.is_bus_mute(indice):
		return 0.0
	return clampf(db_to_linear(AudioServer.get_bus_volume_db(indice)), 0.0, 1.0)


func _on_fase_cambiada(fase: int) -> void:
	match fase:
		EstadoJuego.Fase.MENU:
			reproducir_musica("menu")
		EstadoJuego.Fase.JUGANDO:
			reproducir_musica("nivel")
			_reproductor_musica.volume_db = 0.0
		EstadoJuego.Fase.PAUSA:
			_reproductor_musica.volume_db = ATENUACION_PAUSA_DB
		EstadoJuego.Fase.VICTORIA:
			reproducir_efecto("victoria")
			reproducir_musica("menu")
		EstadoJuego.Fase.DERROTA:
			reproducir_efecto("derrota")


func _on_nodo_agregado(nodo: Node) -> void:
	if nodo is BaseButton:
		(nodo as BaseButton).pressed.connect(reproducir_efecto.bind("boton"))
