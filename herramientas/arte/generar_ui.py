"""Genera los sprites de la interfaz (corazón lleno y vacío, ícono de fragmento del HUD). Arte propio del equipo.

Uso: python generar_ui.py <carpeta_salida>
"""
import sys
from pathlib import Path

from PIL import Image

COLORES = {".": None, "O": (26, 26, 36), "R": (217, 67, 59), "r": (150, 40, 36), "W": (255, 190, 180),
           "G": (70, 72, 88), "g": (50, 52, 64)}
LLENO = [
    ".OO.OO..",
    "ORWORRO.",
    "ORRRRrO.",
    "ORRRRrO.",
    ".ORRrO..",
    "..ORO...",
    "...O....",
    "........",
]


def dibujar(filas: list[str], cambio: dict[str, str] | None = None) -> Image.Image:
    imagen = Image.new("RGBA", (8, 8), (0, 0, 0, 0))
    for y, fila in enumerate(filas):
        for x, s in enumerate(fila):
            s = (cambio or {}).get(s, s)
            if COLORES[s]:
                imagen.putpixel((x, y), COLORES[s] + (255,))
    return imagen


if __name__ == "__main__":
    salida = Path(sys.argv[1])
    salida.mkdir(parents=True, exist_ok=True)
    hoja = Image.new("RGBA", (16, 8), (0, 0, 0, 0))
    hoja.paste(dibujar(LLENO), (0, 0))
    hoja.paste(dibujar(LLENO, {"R": "G", "r": "g", "W": "G"}), (8, 0))
    hoja.save(salida / "corazon.png")
    print("ui en", salida)
