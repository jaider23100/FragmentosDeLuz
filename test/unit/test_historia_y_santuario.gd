extends GutTest
## Pruebas del santuario (RN-06) y de la pantalla narrativa (RF-16).

const EscenaSantuario: PackedScene = preload("res://scenes/objetos/santuario.tscn")
const EscenaIntro: PackedScene = preload("res://scenes/narrativa/intro.tscn")


func before_each() -> void:
	EstadoJuego.reiniciar()
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.JUGANDO)


func test_santuario_no_se_restaura_con_fragmentos_faltantes() -> void:
	var santuario: Santuario = EscenaSantuario.instantiate()
	add_child_autofree(santuario)
	for i: int in 4:
		EstadoJuego.recoger_fragmento()
	assert_false(santuario.intentar_restaurar(), "RN-06: con 4/5 no se gana")
	assert_eq(EstadoJuego.fase, EstadoJuego.Fase.JUGANDO)


func test_santuario_completa_el_nivel_con_los_cinco_fragmentos() -> void:
	var santuario: Santuario = EscenaSantuario.instantiate()
	add_child_autofree(santuario)
	for i: int in 5:
		EstadoJuego.recoger_fragmento()
	watch_signals(EstadoJuego)
	assert_true(santuario.intentar_restaurar(), "RN-06: con 5/5 se gana")
	assert_signal_emitted(EstadoJuego, "nivel_completado")
	assert_eq(EstadoJuego.fase, EstadoJuego.Fase.VICTORIA)


func test_la_introduccion_tiene_cuatro_pantallas_y_avanza() -> void:
	var intro: PantallaNarrativa = EscenaIntro.instantiate()
	intro.escena_siguiente = ""
	add_child_autofree(intro)
	assert_eq(intro.textos.size(), 4, "RF-16: 4 pantallas de introducción")
	intro.avanzar()
	intro.avanzar()
	assert_eq(intro.indice, 1, "Enter completa el texto y luego pasa a la siguiente pantalla")
