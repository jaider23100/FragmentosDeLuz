extends Node
## Estado global de la partida y reglas de negocio RN-01 a RN-10 (autoload EstadoJuego).
##
## Las escenas llaman a sus métodos y escuchan sus señales; este script nunca
## referencia escenas, para poder probarlo con GUT de forma aislada.

signal corazones_cambiados(corazones: int)
signal puntos_cambiados(puntos: int)
signal fragmentos_cambiados(fragmentos: int)
signal jugador_murio
signal nivel_completado(puntaje_final: int)
signal fase_cambiada(fase: Fase)

enum Fase { MENU, JUGANDO, PAUSA, VICTORIA, DERROTA }

const MAX_CORAZONES: int = 3
const TOTAL_FRAGMENTOS: int = 5
const PUNTOS_FRAGMENTO: int = 100
const PUNTOS_MONEDA: int = 10
const PUNTOS_ENEMIGO: int = 50
const BONO_CORAZON: int = 100
const DURACION_INVULNERABILIDAD: float = 1.0

var corazones: int = MAX_CORAZONES
var puntos: int = 0
var fragmentos: int = 0
var tiempo_invulnerable: float = 0.0
var posicion_checkpoint: Vector2 = Vector2.ZERO
var hay_checkpoint: bool = false
var fase: Fase = Fase.MENU


func _process(delta: float) -> void:
	avanzar_tiempo(delta)


## Restaura 3 corazones, 0 puntos, 0 fragmentos y borra el checkpoint (RN-10).
func reiniciar() -> void:
	corazones = MAX_CORAZONES
	puntos = 0
	fragmentos = 0
	tiempo_invulnerable = 0.0
	posicion_checkpoint = Vector2.ZERO
	hay_checkpoint = false
	corazones_cambiados.emit(corazones)
	puntos_cambiados.emit(puntos)
	fragmentos_cambiados.emit(fragmentos)


## Resta un corazón y activa la invulnerabilidad (RN-01, RN-02).
## Con [param forzar] en true ignora la invulnerabilidad (caída al vacío, RN-03).
## Devuelve true si el daño se aplicó.
func recibir_dano(forzar: bool = false) -> bool:
	if corazones <= 0:
		return false
	if esta_invulnerable() and not forzar:
		return false
	corazones -= 1
	tiempo_invulnerable = DURACION_INVULNERABILIDAD
	corazones_cambiados.emit(corazones)
	if corazones == 0:
		cambiar_fase(Fase.DERROTA)
		jugador_murio.emit()
	return true


## Devuelve true mientras dura la invulnerabilidad posterior a un daño.
func esta_invulnerable() -> bool:
	return tiempo_invulnerable > 0.0


## Descuenta [param delta] segundos de la invulnerabilidad restante.
func avanzar_tiempo(delta: float) -> void:
	tiempo_invulnerable = maxf(tiempo_invulnerable - delta, 0.0)


## Suma un fragmento (máximo 5) y sus puntos (RN-04).
func recoger_fragmento() -> void:
	fragmentos = mini(fragmentos + 1, TOTAL_FRAGMENTOS)
	fragmentos_cambiados.emit(fragmentos)
	_sumar_puntos(PUNTOS_FRAGMENTO)


## Suma los puntos de una moneda (RN-04).
func registrar_moneda() -> void:
	_sumar_puntos(PUNTOS_MONEDA)


## Suma los puntos de un enemigo derrotado (RN-04).
func registrar_enemigo_derrotado() -> void:
	_sumar_puntos(PUNTOS_ENEMIGO)


## Guarda [param pos] como punto de reaparición (RN-03).
func activar_checkpoint(pos: Vector2) -> void:
	posicion_checkpoint = pos
	hay_checkpoint = true


## Devuelve el último checkpoint activado o [param inicio] si no hay ninguno (RN-03).
func obtener_punto_reaparicion(inicio: Vector2) -> Vector2:
	return posicion_checkpoint if hay_checkpoint else inicio


## Devuelve true si el jugador tiene los 5 fragmentos (RN-06).
func puede_ganar() -> bool:
	return fragmentos >= TOTAL_FRAGMENTOS


## Texto que muestra el santuario cuando faltan fragmentos, con singular y plural (RN-06).
func mensaje_faltantes() -> String:
	var faltan: int = TOTAL_FRAGMENTOS - fragmentos
	if faltan == 1:
		return "Falta 1 fragmento"
	return "Faltan %d fragmentos" % faltan


## Puntos acumulados más 100 por cada corazón restante (RN-08).
func calcular_puntaje_final() -> int:
	return puntos + corazones * BONO_CORAZON


## Termina el nivel con victoria si hay 5 fragmentos (RN-06, RN-08).
## Devuelve el puntaje final, o -1 si todavía faltan fragmentos.
func completar_nivel() -> int:
	if not puede_ganar():
		return -1
	var puntaje_final: int = calcular_puntaje_final()
	cambiar_fase(Fase.VICTORIA)
	nivel_completado.emit(puntaje_final)
	return puntaje_final


## Cambia la fase del ciclo del juego y avisa con [signal fase_cambiada].
func cambiar_fase(nueva: Fase) -> void:
	if fase == nueva:
		return
	fase = nueva
	fase_cambiada.emit(fase)


func _sumar_puntos(cantidad: int) -> void:
	puntos += cantidad
	puntos_cambiados.emit(puntos)
