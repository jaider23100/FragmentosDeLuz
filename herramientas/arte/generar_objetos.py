"""Genera los sprites de los objetos del nivel de Fragmentos de Luz. Arte propio del equipo.

Uso: python generar_objetos.py <carpeta_salida>
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw

COLORES = {
    ".": None,
    "O": (26, 26, 36),
    "E": (95, 243, 255),     # cian del Cristal
    "e": (47, 184, 200),     # cian oscuro
    "W": (220, 255, 255),    # brillo del cristal
    "Y": (242, 193, 78),     # dorado
    "y": (176, 128, 40),     # dorado oscuro
    "A": (255, 236, 160),    # brillo dorado
    "P": (118, 120, 128),    # piedra
    "p": (78, 80, 90),       # piedra oscura
    "Q": (160, 162, 170),    # piedra clara
    "T": (74, 59, 44),       # madera
    "t": (52, 40, 30),       # madera oscura
    "G": (110, 112, 120),    # tela gris (estandarte inactivo)
    "g": (80, 82, 90),
    "R": (217, 67, 59),      # rojo púas
    "r": (150, 40, 36),
    "M": (46, 59, 50),       # musgo marchito
}

FRAGMENTO = [
    "...OO...",
    "..OWEO..",
    ".OWEEeO.",
    "OWEEEEeO",
    "OEEEEEeO",
    ".OeEEeO.",
    "..OeeO..",
    "...OO...",
]
FRAGMENTO_BRILLO = [
    "...OO...",
    "..OWWO..",
    ".OWWEEO.",
    "OWWEEEEO",
    "OEEEEEeO",
    ".OEEEeO.",
    "..OeeO..",
    "...OO...",
]
MONEDA = [
    "..OOOO..",
    ".OAYYYO.",
    "OAYYYyYO",
    "OAYyYyYO",
    "OYYyYyYO",
    "OYYYYYyO",
    ".OYYyyO.",
    "..OOOO..",
]
MONEDA_GIRO = [
    "...OO...",
    "..OAYO..",
    "..OAYO..",
    "..OYyO..",
    "..OYyO..",
    "..OYyO..",
    "..OYyO..",
    "...OO...",
]
ESTANDARTE = [
    "..OO........",
    ".OYYO.......",
    "..OTOOOOOO..",
    "..OTOFFFFFO.",
    "..OTOFFFFFO.",
    "..OTOFFKFFO.",
    "..OTOFFFFFO.",
    "..OTOFFFFFO.",
    "..OTOOFFFOO.",
    "..OTO.OFO...",
    "..OTO..O....",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    "..OTO.......",
    ".OpPpO......",
    "OPQPPpO.....",
    "OOOOOOO.....",
]
CARTEL = [
    "....OOOOOOO.....",
    "...OQQPPPPPO....",
    "..OQPPPPPPPPO...",
    "..OQPOOOOOPPO...",
    "..OPPPPPPPPpO...",
    "..OPPOOOOPPpO...",
    "..OPPPPPPPPpO...",
    "..OPPOOOOOPpO...",
    "..OPPPPPPPPpO...",
    "..OPPPPPPPPpO...",
    "..OpPPPPPPppO...",
    "..OppppppppMO...",
    "..OOOOOOOOMMO...",
    ".MMMOOOOOOOOMM..",
    "................",
    "................",
]
PUAS = [
    "..O...O...O...O.",
    ".ORO.ORO.ORO.ORO",
    ".ORO.ORO.ORO.ORO",
    "ORrROORrROORrROO",
    "ORrRORRrRORRrROO",
    "OOOOOOOOOOOOOOOO",
    "OppppppppppppppO",
    "OOOOOOOOOOOOOOOO",
]


def dibujar(filas: list[str], reemplazos: dict[str, str] | None = None) -> Image.Image:
    ancho = max(len(f) for f in filas)
    imagen = Image.new("RGBA", (ancho, len(filas)), (0, 0, 0, 0))
    for y, fila in enumerate(filas):
        for x, simbolo in enumerate(fila.ljust(ancho, ".")):
            simbolo = (reemplazos or {}).get(simbolo, simbolo)
            if COLORES[simbolo]:
                imagen.putpixel((x, y), COLORES[simbolo] + (255,))
    return imagen


def roca() -> Image.Image:
    """Roca empujable de 24x24 dibujada con círculos superpuestos."""
    imagen = Image.new("RGBA", (24, 24), (0, 0, 0, 0))
    d = ImageDraw.Draw(imagen)
    d.ellipse([0, 1, 23, 23], fill=COLORES["O"])
    d.ellipse([1, 2, 22, 22], fill=COLORES["p"])
    d.ellipse([1, 2, 19, 18], fill=COLORES["P"])
    d.ellipse([4, 4, 11, 9], fill=COLORES["Q"])
    for x, y in [(14, 12), (15, 13), (8, 15), (17, 8)]:
        imagen.putpixel((x, y), COLORES["p"] + (255,))
    d.line([(3, 20), (20, 20)], fill=COLORES["M"])
    return imagen


def santuario(restaurado: bool) -> Image.Image:
    """Santuario de 32x32: arco de piedra con un altar; restaurado muestra el Cristal completo."""
    imagen = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(imagen)
    d.rectangle([3, 8, 8, 31], fill=COLORES["O"])
    d.rectangle([23, 8, 28, 31], fill=COLORES["O"])
    d.rectangle([4, 9, 7, 30], fill=COLORES["P"])
    d.rectangle([24, 9, 27, 30], fill=COLORES["P"])
    d.arc([3, 0, 28, 18], 180, 360, fill=COLORES["O"], width=3)
    d.arc([4, 1, 27, 17], 180, 360, fill=COLORES["Q"], width=1)
    d.rectangle([10, 24, 21, 31], fill=COLORES["O"])
    d.rectangle([11, 25, 20, 30], fill=COLORES["P"])
    d.line([(11, 25), (20, 25)], fill=COLORES["Q"])
    if restaurado:
        d.polygon([(16, 9), (20, 15), (16, 23), (12, 15)], fill=COLORES["E"], outline=COLORES["O"])
        d.line([(14, 13), (16, 10)], fill=COLORES["W"])
        for x, y in [(9, 12), (22, 11), (10, 20), (21, 19), (16, 6)]:
            imagen.putpixel((x, y), COLORES["W"] + (255,))
    else:
        d.polygon([(16, 15), (18, 19), (16, 23), (14, 19)], outline=COLORES["e"])
    return imagen


def tira(cuadros: list[Image.Image]) -> Image.Image:
    ancho, alto = cuadros[0].size
    hoja = Image.new("RGBA", (ancho * len(cuadros), alto), (0, 0, 0, 0))
    for i, c in enumerate(cuadros):
        hoja.paste(c, (i * ancho, 0), c)
    return hoja


def main() -> None:
    salida = Path(sys.argv[1])
    salida.mkdir(parents=True, exist_ok=True)
    objetos = {
        "fragmento": [dibujar(FRAGMENTO), dibujar(FRAGMENTO_BRILLO)],
        "moneda": [dibujar(MONEDA), dibujar(MONEDA_GIRO)],
        "estandarte": [dibujar(ESTANDARTE, {"F": "G", "K": "g"}), dibujar(ESTANDARTE, {"F": "E", "K": "W"})],
        "cartel": [dibujar(CARTEL)],
        "puas": [dibujar(PUAS)],
        "roca": [roca()],
        "santuario": [santuario(False), santuario(True)],
    }
    for nombre, cuadros in objetos.items():
        tira(cuadros).save(salida / f"{nombre}.png")

    escala, margen = 6, 16
    lamina = Image.new("RGB", (900, 760), (46, 59, 50))
    pincel = ImageDraw.Draw(lamina)
    x, y, alto_fila = margen, margen, 0
    for nombre, cuadros in objetos.items():
        for i, c in enumerate(cuadros):
            grande = c.resize((c.width * escala, c.height * escala), Image.NEAREST)
            if x + grande.width > 900 - margen:
                x, y, alto_fila = margen, y + alto_fila + 30, 0
            lamina.paste(grande, (x, y), grande)
            etiqueta = nombre + ("" if len(cuadros) == 1 else f" {i + 1}")
            pincel.text((x, y + grande.height + 4), etiqueta, fill=(244, 241, 232))
            x += grande.width + margen
            alto_fila = max(alto_fila, grande.height)
    lamina.save(salida / "lamina_objetos.png")
    print("objetos en", salida)


if __name__ == "__main__":
    main()
