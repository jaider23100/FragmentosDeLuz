extends Node
## Guarda y carga el mejor puntaje y el volumen en user://config.cfg (autoload GestorGuardado, RF-19, RNF-08).
##
## Si el archivo no existe, está dañado o tiene otra versión, usa los valores por defecto sin fallar.
## Debe cargarse antes que GestorAudio, que toma de aquí el volumen inicial.

const RUTA: String = "user://config.cfg"
const VERSION_FORMATO: int = 1
const VOLUMEN_POR_DEFECTO: float = 0.8

var mejor_puntaje: int = 0
var volumen_musica: float = VOLUMEN_POR_DEFECTO
var volumen_efectos: float = VOLUMEN_POR_DEFECTO
## Archivo en uso; las pruebas lo cambian para no tocar el guardado real.
var ruta: String = RUTA


func _ready() -> void:
	cargar()


## Lee el archivo de [member ruta]. Ante cualquier problema deja los valores por defecto (RNF-08).
func cargar() -> void:
	_restablecer()
	var archivo := ConfigFile.new()
	var error: Error = archivo.load(ruta)
	if error == ERR_FILE_NOT_FOUND:
		return
	if error != OK:
		push_warning("Archivo de guardado dañado (%s); se usan valores por defecto." % error_string(error))
		return
	if archivo.get_value("meta", "version", 0) != VERSION_FORMATO:
		return
	var puntaje: Variant = archivo.get_value("progreso", "mejor_puntaje", 0)
	if puntaje is int:
		mejor_puntaje = maxi(puntaje as int, 0)
	volumen_musica = _leer_volumen(archivo, "volumen_musica")
	volumen_efectos = _leer_volumen(archivo, "volumen_efectos")


## Escribe los valores actuales en [member ruta]; si falla, avisa y el juego sigue con los valores en memoria.
func guardar() -> Error:
	var archivo := ConfigFile.new()
	archivo.set_value("meta", "version", VERSION_FORMATO)
	archivo.set_value("progreso", "mejor_puntaje", mejor_puntaje)
	archivo.set_value("audio", "volumen_musica", volumen_musica)
	archivo.set_value("audio", "volumen_efectos", volumen_efectos)
	var error: Error = archivo.save(ruta)
	if error != OK:
		push_warning("No se pudo guardar la configuración: %s" % error_string(error))
	return error


## Guarda [param puntaje] si supera estrictamente al mejor (RN-09). Devuelve true si es un nuevo récord.
func registrar_puntaje(puntaje: int) -> bool:
	if puntaje <= mejor_puntaje:
		return false
	mejor_puntaje = puntaje
	guardar()
	return true


## Guarda el volumen de música y efectos (0 a 1), ajustado al rango válido.
func guardar_volumen(musica: float, efectos: float) -> void:
	volumen_musica = clampf(musica, 0.0, 1.0)
	volumen_efectos = clampf(efectos, 0.0, 1.0)
	guardar()


func _leer_volumen(archivo: ConfigFile, clave: String) -> float:
	var valor: Variant = archivo.get_value("audio", clave, VOLUMEN_POR_DEFECTO)
	if valor is float or valor is int:
		return clampf(float(valor), 0.0, 1.0)
	return VOLUMEN_POR_DEFECTO


func _restablecer() -> void:
	mejor_puntaje = 0
	volumen_musica = VOLUMEN_POR_DEFECTO
	volumen_efectos = VOLUMEN_POR_DEFECTO
