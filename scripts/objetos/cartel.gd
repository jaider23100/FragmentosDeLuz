class_name Cartel
extends Area2D
## Cartel de piedra: al acercarse el caballero muestra su texto en el HUD (RF-16, tutorial integrado).

## Texto que se muestra (narrativa y tutorial del GDD 2.2).
@export_multiline var texto: String = ""


## Muestra el texto en el HUD del nivel.
func mostrar() -> void:
	var hud: Hud = get_tree().get_first_node_in_group("hud") as Hud
	if hud != null:
		hud.mostrar_texto_cartel(texto)


## Oculta el texto del HUD.
func ocultar() -> void:
	var hud: Hud = get_tree().get_first_node_in_group("hud") as Hud
	if hud != null:
		hud.ocultar_texto_cartel()


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		mostrar()


func _on_body_exited(body: Node2D) -> void:
	if body is Caballero:
		ocultar()
