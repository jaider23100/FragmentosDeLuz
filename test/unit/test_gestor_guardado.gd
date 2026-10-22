extends GutTest
## Pruebas de la persistencia en user:// (RF-19, RNF-08, RN-09). Usan un archivo de prueba, nunca el guardado real.

const RUTA_PRUEBA: String = "user://prueba_config.cfg"


func before_each() -> void:
	GestorGuardado.ruta = RUTA_PRUEBA
	DirAccess.remove_absolute(RUTA_PRUEBA)


func after_each() -> void:
	DirAccess.remove_absolute(RUTA_PRUEBA)
	GestorGuardado.ruta = GestorGuardado.RUTA
	GestorGuardado.cargar()


func _escribir_archivo(contenido: String) -> void:
	var archivo := FileAccess.open(RUTA_PRUEBA, FileAccess.WRITE)
	archivo.store_string(contenido)
	archivo.close()


func test_sin_archivo_usa_valores_por_defecto() -> void:
	GestorGuardado.cargar()
	assert_eq(GestorGuardado.mejor_puntaje, 0, "HU-21 E2: sin archivo el mejor puntaje es 0")
	assert_eq(GestorGuardado.volumen_musica, GestorGuardado.VOLUMEN_POR_DEFECTO, "HU-21 E2: volumen por defecto")


func test_archivo_danado_usa_valores_por_defecto_sin_fallar() -> void:
	_escribir_archivo("[progreso\nmejor_puntaje=== esto no es un ConfigFile")
	GestorGuardado.cargar()
	# El error de lectura del motor y el aviso del gestor son esperados: el juego no se detiene.
	assert_engine_error("ConfigFile parse error", "RNF-08: Godot informa el archivo dañado")
	assert_engine_error("Archivo de guardado dañado", "RNF-08: el gestor avisa y sigue")
	assert_eq(GestorGuardado.mejor_puntaje, 0, "RNF-08: archivo dañado -> mejor puntaje 0")
	assert_eq(GestorGuardado.volumen_efectos, GestorGuardado.VOLUMEN_POR_DEFECTO, "RNF-08: archivo dañado -> volumen por defecto")


func test_volumen_fuera_de_rango_se_ajusta() -> void:
	_escribir_archivo("[meta]\nversion=1\n\n[progreso]\nmejor_puntaje=-50\n\n[audio]\nvolumen_musica=3.5\nvolumen_efectos=\"alto\"\n")
	GestorGuardado.cargar()
	assert_eq(GestorGuardado.volumen_musica, 1.0, "Volumen 3.5 se ajusta a 1.0")
	assert_eq(GestorGuardado.volumen_efectos, GestorGuardado.VOLUMEN_POR_DEFECTO, "Un volumen que no es número usa el valor por defecto")
	assert_eq(GestorGuardado.mejor_puntaje, 0, "Un puntaje negativo se ajusta a 0")


func test_guardar_y_recargar_conserva_los_valores() -> void:
	GestorGuardado.mejor_puntaje = 1700
	GestorGuardado.guardar_volumen(0.6, 0.3)
	GestorGuardado.mejor_puntaje = 0
	GestorGuardado.volumen_musica = 0.0
	GestorGuardado.cargar()
	assert_eq(GestorGuardado.mejor_puntaje, 1700, "HU-21 E1: el mejor puntaje sobrevive al cierre")
	assert_almost_eq(GestorGuardado.volumen_musica, 0.6, 0.001, "HU-21: el volumen de música se conserva")
	assert_almost_eq(GestorGuardado.volumen_efectos, 0.3, 0.001, "HU-21: el volumen de efectos se conserva")


func test_mejor_puntaje_solo_cambia_si_es_estrictamente_mayor() -> void:
	GestorGuardado.cargar()
	assert_true(GestorGuardado.registrar_puntaje(1650), "Primer puntaje: nuevo récord")
	assert_false(GestorGuardado.registrar_puntaje(1500), "RN-09: 1500 no supera 1650")
	assert_false(GestorGuardado.registrar_puntaje(1650), "RN-09: igualar no es récord")
	assert_true(GestorGuardado.registrar_puntaje(1700), "RN-09: 1700 supera 1650")
	assert_eq(GestorGuardado.mejor_puntaje, 1700, "RN-09: queda 1700")
