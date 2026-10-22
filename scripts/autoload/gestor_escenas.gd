extends Node
## Cambia entre las pantallas del juego con rutas centralizadas (autoload GestorEscenas).

const MENU: String = "res://scenes/ui/menu_principal.tscn"
const INTRO: String = "res://scenes/narrativa/intro.tscn"
const NIVEL: String = "res://scenes/niveles/nivel_bosque.tscn"
const FINAL: String = "res://scenes/narrativa/final.tscn"
const VICTORIA: String = "res://scenes/ui/victoria.tscn"
const DERROTA: String = "res://scenes/ui/derrota.tscn"
const CREDITOS: String = "res://scenes/ui/creditos.tscn"


## Carga la escena de [param ruta]. Si no existe o falla, vuelve al menú (CU-01 E1).
func cambiar_escena(ruta: String) -> void:
	get_tree().paused = false
	if not ResourceLoader.exists(ruta):
		push_error("Escena no encontrada: %s" % ruta)
		_volver_al_menu(ruta)
		return
	var error: Error = get_tree().change_scene_to_file(ruta)
	if error != OK:
		push_error("No se pudo cargar %s: %s" % [ruta, error_string(error)])
		_volver_al_menu(ruta)


## Reinicia el estado de la partida y abre la primera pantalla del juego (CU-01).
func iniciar_partida() -> void:
	EstadoJuego.reiniciar()
	cambiar_escena(INTRO)


func _volver_al_menu(ruta_fallida: String) -> void:
	if ruta_fallida != MENU:
		get_tree().change_scene_to_file(MENU)
