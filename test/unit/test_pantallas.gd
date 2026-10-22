extends GutTest
## Pruebas de la pantalla de victoria (RN-08) y del panel de opciones (RF-18).

const EscenaVictoria: PackedScene = preload("res://scenes/ui/victoria.tscn")
const EscenaOpciones: PackedScene = preload("res://scenes/ui/opciones.tscn")


func before_each() -> void:
	EstadoJuego.reiniciar()


func after_each() -> void:
	GestorAudio.aplicar_volumen("Musica", GestorAudio.VOLUMEN_POR_DEFECTO)
	GestorAudio.aplicar_volumen("Efectos", GestorAudio.VOLUMEN_POR_DEFECTO)


func test_victoria_muestra_el_puntaje_final_con_bono() -> void:
	for i: int in 5:
		EstadoJuego.recoger_fragmento()
	EstadoJuego.recibir_dano()
	var victoria: Victoria = EscenaVictoria.instantiate()
	add_child_autofree(victoria)
	assert_eq(victoria.get_node("%EtiquetaBono").text, "Bono por corazones: +200", "RN-08: 2 corazones x 100")
	assert_eq(victoria.get_node("%EtiquetaTotal").text, "Total: 700", "RN-08: 500 + 200")


func test_opciones_silencia_la_musica_sin_afectar_los_efectos() -> void:
	var opciones: Opciones = EscenaOpciones.instantiate()
	add_child_autofree(opciones)
	opciones.abrir()
	opciones.get_node("%SliderMusica").value = 0.0
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index("Musica")), "HU-20: música al 0 % queda en silencio")
	assert_false(AudioServer.is_bus_mute(AudioServer.get_bus_index("Efectos")), "HU-20: los efectos siguen sonando")
