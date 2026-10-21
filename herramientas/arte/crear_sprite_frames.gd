extends SceneTree
## Crea los recursos SpriteFrames (.tres) de los personajes a partir de sus hojas de sprites.
##
## Uso: godot --headless --path . --script res://herramientas/arte/crear_sprite_frames.gd

const PERSONAJES: Dictionary = {
	"res://assets/sprites/caballero/caballero_frames.tres": {
		"carpeta": "res://assets/sprites/caballero/caballero_",
		"tamano": 24,
		"animaciones": {
			"quieto": [2, 2.0, true], "caminar": [4, 8.0, true], "saltar": [1, 1.0, false],
			"caer": [1, 1.0, false], "doble_salto": [1, 1.0, false], "dash": [1, 1.0, false],
			"atacar": [2, 8.0, false], "herido": [1, 1.0, false], "muerto": [1, 1.0, false],
		},
	},
	"res://assets/sprites/enemigos/slime/slime_frames.tres": {
		"carpeta": "res://assets/sprites/enemigos/slime/slime_",
		"tamano": 16,
		"animaciones": {"moverse": [2, 4.0, true]},
	},
	"res://assets/sprites/enemigos/murcielago/murcielago_frames.tres": {
		"carpeta": "res://assets/sprites/enemigos/murcielago/murcielago_",
		"tamano": 16,
		"animaciones": {"dormido": [1, 1.0, false], "volar": [2, 8.0, true]},
	},
}


func _init() -> void:
	for ruta: String in PERSONAJES:
		var datos: Dictionary = PERSONAJES[ruta]
		var frames := SpriteFrames.new()
		frames.remove_animation("default")
		var tamano: int = datos["tamano"]
		for nombre: String in datos["animaciones"]:
			var config: Array = datos["animaciones"][nombre]
			var hoja: Texture2D = load(datos["carpeta"] + nombre + ".png")
			frames.add_animation(nombre)
			frames.set_animation_speed(nombre, config[1])
			frames.set_animation_loop(nombre, config[2])
			for i: int in config[0]:
				var cuadro := AtlasTexture.new()
				cuadro.atlas = hoja
				cuadro.region = Rect2(i * tamano, 0, tamano, tamano)
				frames.add_frame(nombre, cuadro)
		var error: Error = ResourceSaver.save(frames, ruta)
		print(ruta, ": ", error_string(error))
	quit()
