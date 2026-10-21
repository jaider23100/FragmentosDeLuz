"""Convierte el tileset de Brackeys (CC0) en el Bosque Marchito. Modificación propia del equipo.

1. Los verdes (pasto, hojas) pasan a tonos oliva y café secos.
2. Toda la imagen se desatura y se oscurece con un tinte verde grisáceo.
Uso: python oscurecer_tileset.py <original.png> <salida.png>
"""
import colorsys
import sys

from PIL import Image

TINTE = (0.66, 0.70, 0.64)
TONO_SECO = 38 / 360          # oliva / café
RANGO_VERDE = (60 / 360, 170 / 360)


def marchitar(r: int, g: int, b: int) -> tuple[int, int, int]:
    h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    if RANGO_VERDE[0] <= h <= RANGO_VERDE[1] and s > 0.2:
        h, s, v = TONO_SECO, s * 0.55, v * 0.85
    r, g, b = (int(c * 255) for c in colorsys.hsv_to_rgb(h, s, v))
    gris = (r + g + b) / 3
    return tuple(int((c * 0.6 + gris * 0.4) * t) for c, t in zip((r, g, b), TINTE))


def main() -> None:
    imagen = Image.open(sys.argv[1]).convert("RGBA")
    pixeles = imagen.load()
    for y in range(imagen.height):
        for x in range(imagen.width):
            r, g, b, a = pixeles[x, y]
            if a:
                pixeles[x, y] = marchitar(r, g, b) + (a,)
    imagen.save(sys.argv[2])
    print("tileset marchito:", sys.argv[2])


if __name__ == "__main__":
    main()
