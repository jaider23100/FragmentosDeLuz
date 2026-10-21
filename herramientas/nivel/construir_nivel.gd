extends Node
## Construye scenes/niveles/nivel_bosque.tscn: tileset con colisiones, terreno y todas las instancias.
##
## Los objetos cuya escena todavía no existe se omiten, así que se puede volver a ejecutar
## cuando el equipo agregue escenas nuevas (murciélagos, carteles, santuario).
## Uso: godot --headless --path . res://herramientas/nivel/construir_nivel.tscn

const RUTA_NIVEL: String = "res://scenes/niveles/nivel_bosque.tscn"
const RUTA_TILESET: String = "res://assets/sprites/tileset/tileset_bosque.tres"
const TEXTURA_TILESET: String = "res://assets/sprites/tileset/tileset_bosque_marchito.png"
const TAMANO_TILE: int = 16
const ANCHO_TILES: int = 240
const COLOR_FONDO: Color = Color(0.18, 0.231, 0.196)

const PASTO: Vector2i = Vector2i(0, 0)
const TIERRA: Vector2i = Vector2i(0, 1)
const PIEDRA_SUPERIOR: Vector2i = Vector2i(2, 0)
const PIEDRA: Vector2i = Vector2i(2, 1)
const DECORACION: Array[Vector2i] = [Vector2i(0, 3), Vector2i(0, 4), Vector2i(0, 5), Vector2i(1, 5)]

## Terreno: [columna inicial, columna final, fila superior, fila inferior, estilo]
const TERRENO: Array = [
	[0, 47, 25, 29, "pasto"],       # zona 1
	[48, 50, 28, 29, "tierra"],     # fondo del foso con púas (zona 2)
	[51, 199, 25, 29, "pasto"],     # zonas 2 a 4 y comienzo de la 5
	[208, 239, 25, 29, "pasto"],    # final de la zona 5, después del hueco largo
	[26, 29, 23, 23, "pasto"],      # plataforma del F1
	[69, 71, 21, 21, "pasto"],      # cornisa del F2 (exige doble salto)
	[115, 124, 11, 11, "pasto"],    # plataforma alta de la zona 3 (se llega con el viento)
	[150, 179, 25, 25, "piedra"],   # suelo de las ruinas (zona 4)
	[165, 169, 20, 20, "piedra"],   # cornisa del F4 (exige la roca)
	[-1, -1, 0, 29, "tierra"],      # pared izquierda
	[240, 240, 0, 29, "tierra"],    # pared derecha
]
## Árboles y arbustos de fondo: [columna, fila del suelo]
const ARBOLES: Array[Vector2i] = [Vector2i(5, 25), Vector2i(20, 25), Vector2i(60, 25), Vector2i(95, 25), Vector2i(135, 25), Vector2i(185, 25), Vector2i(225, 25)]
const ARBUSTOS: Array[Vector2i] = [Vector2i(12, 25), Vector2i(40, 25), Vector2i(80, 25), Vector2i(110, 25), Vector2i(190, 25), Vector2i(215, 25)]

const INICIO: Vector2 = Vector2(40, 392)
## Instancias: [ruta de la escena, nodo padre, nombre, posición, propiedades]
const INSTANCIAS: Array = [
	["res://scenes/enemigos/slime.tscn", "Enemigos", "Slime1", Vector2(250, 396), {}],
	["res://scenes/enemigos/slime.tscn", "Enemigos", "Slime2", Vector2(560, 396), {}],
	["res://scenes/enemigos/slime.tscn", "Enemigos", "Slime3", Vector2(1250, 396), {}],
	["res://scenes/enemigos/slime.tscn", "Enemigos", "Slime4", Vector2(2450, 396), {}],
	["res://scenes/enemigos/murcielago.tscn", "Enemigos", "Murcielago1", Vector2(2000, 330), {}],
	["res://scenes/enemigos/murcielago.tscn", "Enemigos", "Murcielago2", Vector2(2700, 300), {}],
	["res://scenes/enemigos/murcielago.tscn", "Enemigos", "Murcielago3", Vector2(3420, 320), {}],
	["res://scenes/objetos/checkpoint.tscn", "Objetos", "Checkpoint1", Vector2(1450, 393), {}],
	["res://scenes/objetos/checkpoint.tscn", "Objetos", "Checkpoint2", Vector2(2950, 393), {}],
	["res://scenes/objetos/fragmento.tscn", "Objetos", "F1", Vector2(448, 356), {}],
	["res://scenes/objetos/fragmento.tscn", "Objetos", "F2", Vector2(1128, 324), {}],
	["res://scenes/objetos/fragmento.tscn", "Objetos", "F3", Vector2(1920, 164), {}],
	["res://scenes/objetos/fragmento.tscn", "Objetos", "F4", Vector2(2680, 308), {}],
	["res://scenes/objetos/fragmento.tscn", "Objetos", "F5", Vector2(3264, 360), {}],
	["res://scenes/objetos/roca.tscn", "Objetos", "Roca", Vector2(2560, 390), {}],
	["res://scenes/objetos/viento.tscn", "Objetos", "Viento", Vector2(1820, 400), {"tamano": Vector2(40, 232)}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas1", Vector2(776, 448), {}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas2", Vector2(792, 448), {}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas3", Vector2(808, 448), {}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas4", Vector2(3160, 400), {}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas5", Vector2(3176, 400), {}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas6", Vector2(3400, 400), {}],
	["res://scenes/objetos/puas.tscn", "Objetos", "Puas7", Vector2(3416, 400), {}],
	["res://scenes/objetos/cartel.tscn", "Objetos", "Cartel1", Vector2(80, 400), {"texto": "CARTEL_1"}],
	["res://scenes/objetos/cartel.tscn", "Objetos", "Cartel2", Vector2(860, 400), {"texto": "CARTEL_2"}],
	["res://scenes/objetos/cartel.tscn", "Objetos", "Cartel3", Vector2(1760, 400), {"texto": "CARTEL_3"}],
	["res://scenes/objetos/santuario.tscn", "Objetos", "Santuario", Vector2(3780, 400), {}],
	["res://scenes/jugador/caballero.tscn", ".", "Caballero", INICIO, {}],
	["res://scenes/ui/hud.tscn", ".", "Hud", Vector2.ZERO, {}],
	["res://scenes/ui/menu_pausa.tscn", ".", "MenuPausa", Vector2.ZERO, {}],
]
const MONEDAS: Array[Vector2] = [
	Vector2(300, 380), Vector2(320, 380), Vector2(340, 380), Vector2(432, 352),
	Vector2(900, 370), Vector2(920, 370),
	Vector2(1820, 300), Vector2(1820, 260), Vector2(1820, 220), Vector2(1870, 164), Vector2(1960, 164),
	Vector2(2500, 380), Vector2(2520, 380), Vector2(2540, 380),
	Vector2(3150, 370), Vector2(3190, 370), Vector2(3360, 370), Vector2(3380, 370), Vector2(3600, 380), Vector2(3620, 380),
]
## Textos de los carteles de piedra (GDD 2.2): narrativa y tutorial.
const TEXTOS_CARTELES: Dictionary = {
	"CARTEL_1": "Guardián: la sombra robó el Cristal. Muévete con A/D, salta con Espacio y usa tu espada con J.",
	"CARTEL_2": "El salto bendecido te eleva otra vez en el aire (Espacio). La embestida de escudo cruza el abismo (Shift).",
	"CARTEL_3": "El aliento del bosque aún sopla. Entra en la corriente y déjate llevar hacia lo alto.",
}


func _ready() -> void:
	var tileset: TileSet = _crear_tileset()
	var raiz := Node2D.new()
	raiz.name = "NivelBosque"
	raiz.set_script(load("res://scripts/niveles/nivel_bosque.gd"))

	var fondo := ColorRect.new()
	fondo.name = "Fondo"
	fondo.color = COLOR_FONDO
	fondo.z_index = -10
	fondo.position = Vector2(-200, -200)
	fondo.size = Vector2(ANCHO_TILES * TAMANO_TILE + 400, 900)
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_agregar(raiz, raiz, fondo)

	var decoracion := TileMapLayer.new()
	decoracion.name = "Decoracion"
	decoracion.tile_set = tileset
	decoracion.z_index = -5
	decoracion.modulate = Color(0.8, 0.85, 0.82)
	_agregar(raiz, raiz, decoracion)
	_pintar_decoracion(decoracion)

	var terreno := TileMapLayer.new()
	terreno.name = "Terreno"
	terreno.tile_set = tileset
	_agregar(raiz, raiz, terreno)
	_pintar_terreno(terreno)

	for nombre: String in ["Enemigos", "Objetos"]:
		var grupo := Node2D.new()
		grupo.name = nombre
		_agregar(raiz, raiz, grupo)
	var marcador := Marker2D.new()
	marcador.name = "PosicionInicio"
	marcador.position = INICIO
	_agregar(raiz, raiz, marcador)

	for datos: Array in INSTANCIAS:
		_instanciar(raiz, datos[0], datos[1], datos[2], datos[3], datos[4])
	for i: int in MONEDAS.size():
		_instanciar(raiz, "res://scenes/objetos/moneda.tscn", "Objetos", "Moneda%d" % (i + 1), MONEDAS[i], {})

	var escena := PackedScene.new()
	var error: Error = escena.pack(raiz)
	if error == OK:
		error = ResourceSaver.save(escena, RUTA_NIVEL)
	print("Nivel guardado: ", error_string(error))
	raiz.free()
	get_tree().quit()


func _crear_tileset() -> TileSet:
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(TAMANO_TILE, TAMANO_TILE)
	tileset.add_physics_layer()
	tileset.set_physics_layer_collision_layer(0, 1)
	tileset.set_physics_layer_collision_mask(0, 0)
	var fuente := TileSetAtlasSource.new()
	fuente.texture = load(TEXTURA_TILESET)
	fuente.texture_region_size = Vector2i(TAMANO_TILE, TAMANO_TILE)
	tileset.add_source(fuente, 0)
	var mitad: float = TAMANO_TILE / 2.0
	var cuadrado := PackedVector2Array([Vector2(-mitad, -mitad), Vector2(mitad, -mitad), Vector2(mitad, mitad), Vector2(-mitad, mitad)])
	for coordenada: Vector2i in [PASTO, TIERRA, PIEDRA_SUPERIOR, PIEDRA]:
		fuente.create_tile(coordenada)
		var datos: TileData = fuente.get_tile_data(coordenada, 0)
		datos.add_collision_polygon(0)
		datos.set_collision_polygon_points(0, 0, cuadrado)
	for coordenada: Vector2i in DECORACION:
		fuente.create_tile(coordenada)
	ResourceSaver.save(tileset, RUTA_TILESET)
	return load(RUTA_TILESET)


func _pintar_terreno(capa: TileMapLayer) -> void:
	for bloque: Array in TERRENO:
		var superior: Vector2i = PIEDRA_SUPERIOR if bloque[4] == "piedra" else PASTO
		var relleno: Vector2i = PIEDRA if bloque[4] == "piedra" else TIERRA
		if bloque[4] == "tierra":
			superior = TIERRA
		for x: int in range(bloque[0], bloque[1] + 1):
			for y: int in range(bloque[2], bloque[3] + 1):
				capa.set_cell(Vector2i(x, y), 0, superior if y == bloque[2] else relleno)


func _pintar_decoracion(capa: TileMapLayer) -> void:
	for base: Vector2i in ARBOLES:
		for i: int in 3:
			capa.set_cell(base + Vector2i(0, i - 3), 0, DECORACION[i])
	for base: Vector2i in ARBUSTOS:
		capa.set_cell(base + Vector2i(0, -1), 0, DECORACION[3])


func _instanciar(raiz: Node, ruta: String, padre: String, nombre: String, posicion: Vector2, propiedades: Dictionary) -> void:
	if not ResourceLoader.exists(ruta):
		print("  (omitido, aún no existe) ", ruta)
		return
	var nodo: Node = (load(ruta) as PackedScene).instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	nodo.name = nombre
	if nodo is Node2D:
		(nodo as Node2D).position = posicion
	for clave: String in propiedades:
		var valor: Variant = propiedades[clave]
		if valor is String and TEXTOS_CARTELES.has(valor):
			valor = TEXTOS_CARTELES[valor]
		nodo.set(clave, valor)
	_agregar(raiz, raiz.get_node(padre), nodo)


func _agregar(raiz: Node, padre: Node, nodo: Node) -> void:
	padre.add_child(nodo)
	nodo.owner = raiz
