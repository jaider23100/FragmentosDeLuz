extends GutTest
## Pruebas de la pantalla de créditos (RF-18, HU-22).

const EscenaCreditos: PackedScene = preload("res://scenes/ui/creditos.tscn")


func test_creditos_muestran_equipo_licencias_y_aviso_de_godot() -> void:
	var creditos: Creditos = EscenaCreditos.instantiate()
	add_child_autofree(creditos)
	var texto: String = creditos.get_node("%EtiquetaTexto").text
	for integrante: String in ["Jaider Villamizar", "Camilo Vargas", "Kevin Yaruro", "Diego Villamizar"]:
		assert_string_contains(texto, integrante, "HU-22: aparece %s" % integrante)
	assert_string_contains(texto, "CC0", "HU-22: recursos de terceros con su licencia")
	assert_string_contains(texto, "Godot Engine", "HU-22: aviso de Godot")
	assert_string_contains(texto, "Licencia MIT", "HU-22: licencia de Godot y GUT")


func test_el_texto_sube_solo() -> void:
	var creditos: Creditos = EscenaCreditos.instantiate()
	add_child_autofree(creditos)
	await wait_seconds(1.0)
	assert_gt(creditos.get_node("%Desplazamiento").scroll_vertical, 0, "HU-22: los créditos se desplazan solos")
