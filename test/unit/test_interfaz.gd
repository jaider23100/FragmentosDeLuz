extends GutTest
## Pruebas del HUD (RF-14) y del menú de pausa (RF-15).

const EscenaHud: PackedScene = preload("res://scenes/ui/hud.tscn")
const EscenaPausa: PackedScene = preload("res://scenes/ui/menu_pausa.tscn")


func before_each() -> void:
	EstadoJuego.reiniciar()
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.JUGANDO)


func after_each() -> void:
	get_tree().paused = false


func test_hud_se_actualiza_al_recoger_un_fragmento() -> void:
	var hud: Hud = EscenaHud.instantiate()
	add_child_autofree(hud)
	EstadoJuego.recoger_fragmento()
	assert_eq(hud.get_node("%EtiquetaFragmentos").text, "1/5", "RF-14: contador de fragmentos")
	assert_eq(hud.get_node("%EtiquetaPuntos").text, "100 pts", "RF-14: puntaje")


func test_hud_muestra_corazon_vacio_al_recibir_dano() -> void:
	var hud: Hud = EscenaHud.instantiate()
	add_child_autofree(hud)
	EstadoJuego.recibir_dano()
	var tercero: TextureRect = hud.get_node("%Corazon3")
	assert_eq((tercero.texture as AtlasTexture).region.position.x, 8.0, "RF-14: el tercer corazón queda vacío")


func test_pausa_detiene_y_reanuda_el_juego() -> void:
	var pausa: MenuPausa = EscenaPausa.instantiate()
	add_child_autofree(pausa)
	pausa.pausar()
	assert_true(get_tree().paused, "RF-15: el árbol queda en pausa")
	assert_eq(EstadoJuego.fase, EstadoJuego.Fase.PAUSA)
	pausa.reanudar()
	assert_false(get_tree().paused, "RF-15: el juego se reanuda")
	assert_eq(EstadoJuego.fase, EstadoJuego.Fase.JUGANDO)
