"""Genera las hojas de sprites de los personajes de Fragmentos de Luz. Arte propio del equipo.

Cada animación es una tira horizontal de cuadros (caballero 24x24; slime y murciélago 16x16).
Uso: python generar_personajes.py <carpeta_salida>
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw

COLORES = {
    ".": None,
    "O": (26, 26, 36), "H": (248, 246, 238), "S": (200, 205, 218), "s": (140, 147, 166),
    "V": (20, 20, 28), "E": (95, 243, 255), "C": (52, 104, 184), "c": (30, 62, 120),
    "b": (107, 74, 43), "g": (226, 184, 60), "K": (232, 236, 244), "k": (150, 158, 176),
    "B": (70, 72, 88),
    "M": (74, 44, 102), "m": (46, 26, 64), "L": (138, 106, 176), "R": (255, 90, 122),
    "W": (59, 35, 80), "X": (217, 67, 59),
}

# --- Sir Aldric (24x24) ---------------------------------------------------
CABEZA = [
    "........................",
    "..........CCC...........",
    "........CCCCcO..........",
    ".......CcOOOOOO.........",
    "......Cc.OHHSSSO........",
    ".........OHSSSSSO.......",
    "........OHSSSSSSSO......",
    "........OSSOOOOOSO......",
    "........OSSVEVVEVO......",
    "........OsSSSOVSSO......",
    "........OsSSSOVSsO......",
    ".........OssSSSssO......",
    "......ccOOOOOOOOOO......",
]
TORSO = [
    ".....cCCOSSHHSSSsOOO....",
    "....cCCCOSHSSSSsOSSsO...",
    "....cCCcOSSSSSSsOOssO...",
    "....cCcCOSSSSSssOOOO....",
    "....cCcCObbgbbbbOsSO....",
    "....cCcCOsSSOSSsOgggO...",
]
PIERNAS_QUIETO = [
    "....ccCcOsSOOsSsO.KO....",
    "....cc.cOSsO.OSsO.KO....",
    ".....c..OBBO.OBBOOkO....",
    "........OBBBOOBBBO.O....",
    "........OOOOOOOOOO......",
]
PIERNAS_PASO_A = [
    "....ccCcOsSOOsSsO.KO....",
    "....cc.cOSsO..OSsOKO....",
    ".....c.OBBO....OBBOkO...",
    ".......OBBBO...OBBBOO...",
    ".......OOOOO...OOOOO....",
]
PIERNAS_PASO_B = [
    "....ccCcOsSOOsSsO.KO....",
    "....cc.OSsO.OSsO..KO....",
    ".....cOBBO..OBBO..kO....",
    "....OBBBO...OBBBO..O....",
    "....OOOOO...OOOOO.......",
]
PIERNAS_SALTO = [
    "....ccCcOsSSSSsO.KO.....",
    "...cc..OBBOOBBO..KO.....",
    "...c...OBBBOBBBO.kO.....",
    "........OOOOOOO...O.....",
    "........................",
]
TORSO_ATAQUE = [
    ".....cCCOSSHHSSSsOOOOOOO",
    "....cCCCOSHSSSSsOgKKKKKO",
    "....cCCcOSSSSSSsOOkkkkkO",
    "....cCcCOSSSSSssOOOOOOOO",
    "....cCcCObbgbbbbO.......",
    "....cCcCOsSSSSSsO.......",
]
DASH = [
    "........................",
    "........................",
    "........................",
    "...........CCC..........",
    ".........CCCCcO.........",
    "........CcOOOOOOO.......",
    "..........OHHSSSSO......",
    "..........OHSSSSSSO.....",
    "..........OSSOOOOOSO....",
    "..........OSSVEVVEVO....",
    "..........OsSSSOVSSO....",
    "cc.......OOOsSSSssO.....",
    "cCCcc...OSSHHSSSsOOOOOOO",
    ".ccCCCCcOSHSSSSsOgKKKKKO",
    "...ccCCcOSSSSSssOOkkkkkO",
    ".....ccCObbgbbbbOOOOOOOO",
    "......ccOsSSSSSsO.......",
    "......OsSOOOOsSsO.......",
    ".....OBBO...OSsSO.......",
    "....OBBBO....OBBBO......",
    "....OOOO.....OOOOO......",
    "........................",
    "........................",
    "........................",
]


def sin_espada(filas: list[str]) -> list[str]:
    """Quita la hoja de la espada que cuelga junto a las piernas."""
    return [f[:17] + f[17:].replace("K", ".").replace("k", ".") for f in filas]


def con_espada_alzada(filas: list[str]) -> list[str]:
    """Pose de preparación: la espada sube por encima del hombro."""
    nuevas = [list(f) for f in sin_espada(filas)]
    for y in range(5, 18):
        for x in (17, 18, 19):
            if nuevas[y][x] in "Kk":
                nuevas[y][x] = "."
    for y in range(6, 17):
        nuevas[y][18] = "K"
        nuevas[y][19] = "O"
        if nuevas[y][17] == ".":
            nuevas[y][17] = "O"
    nuevas[5][18] = "O"
    nuevas[17][17:20] = list("ggg")
    return ["".join(f) for f in nuevas]


QUIETO = CABEZA + TORSO + PIERNAS_QUIETO
QUIETO_2 = CABEZA[:2] + [CABEZA[2].replace("CCCCc", "CCCCC")] + CABEZA[3:] + TORSO + [PIERNAS_QUIETO[0].replace("ccCc", "cCCc")] + PIERNAS_QUIETO[1:]
CAMINAR = [CABEZA + TORSO + PIERNAS_PASO_A, QUIETO, CABEZA + TORSO + PIERNAS_PASO_B, QUIETO]
SALTO = CABEZA + TORSO + PIERNAS_SALTO
ATAQUE = [con_espada_alzada(QUIETO), CABEZA + TORSO_ATAQUE + sin_espada(PIERNAS_QUIETO)]


def dibujar(filas: list[str], ancho: int) -> Image.Image:
    imagen = Image.new("RGBA", (ancho, len(filas)), (0, 0, 0, 0))
    for y, fila in enumerate(filas):
        for x, simbolo in enumerate(fila.ljust(ancho, ".")[:ancho]):
            if COLORES[simbolo]:
                imagen.putpixel((x, y), COLORES[simbolo] + (255,))
    return imagen


def capa_hacia_arriba(imagen: Image.Image, filas: int = 2) -> Image.Image:
    """Para la caída: los píxeles de la capa (a la izquierda del cuerpo) suben."""
    resultado = imagen.copy()
    capa = [COLORES["C"] + (255,), COLORES["c"] + (255,)]
    for y in range(imagen.height):
        for x in range(8):
            if imagen.getpixel((x, y)) in capa:
                resultado.putpixel((x, y), (0, 0, 0, 0))
    for y in range(imagen.height):
        for x in range(8):
            pixel = imagen.getpixel((x, y))
            if pixel in capa and y - filas >= 0:
                resultado.putpixel((x, y - filas), pixel)
    return resultado


def con_destellos(imagen: Image.Image) -> Image.Image:
    """Para el doble salto: chispas de luz del Cristal bajo los pies."""
    resultado = imagen.copy()
    for x, y in [(8, 21), (11, 22), (14, 21), (10, 23), (13, 23)]:
        resultado.putpixel((x, y), COLORES["E"] + (255,))
    return resultado


def tenido_rojo(imagen: Image.Image) -> Image.Image:
    resultado = imagen.copy()
    for y in range(imagen.height):
        for x in range(imagen.width):
            r, g, b, a = imagen.getpixel((x, y))
            if a:
                resultado.putpixel((x, y), (min(255, r + 90), int(g * 0.55), int(b * 0.55), a))
    return resultado


def caido(imagen: Image.Image) -> Image.Image:
    """El caballero acostado de espaldas, con la cabeza a la izquierda, apoyado en el borde inferior."""
    figura = imagen.crop(imagen.getbbox()).rotate(90, expand=True)
    lienzo = Image.new("RGBA", imagen.size, (0, 0, 0, 0))
    x = (imagen.width - figura.width) // 2
    lienzo.paste(figura, (max(x, 0), imagen.height - figura.height), figura)
    return lienzo


# --- Slime (16x16) --------------------------------------------------------
SLIME = [
    "................"] * 8 + [
    "......OOOO......",
    "....OOMMLMOO....",
    "...OMMMMMLMMO...",
    "..OMMRMMMMRMMO..",
    "..OMMMMMMMMMMO..",
    "..OmmmmmmmmmmO..",
    "...OOOOOOOOOO...",
    "................",
]
SLIME_APLASTADO = ["................"] * 9 + [
    ".....OOOOOO.....",
    "...OOMMMMLMOO...",
    ".OOMMRMMMMRMMOO.",
    ".OMMMMMMMMMMMMO.",
    ".OmmmmmmmmmmmmO.",
    "..OOOOOOOOOOOO..",
    "................",
]

# --- Murciélago (16x16) ---------------------------------------------------
MURCIELAGO_ARRIBA = [
    "................", "................", "................",
    "......O..O......",
    ".....OMOOMO.....",
    "OO..OMMMMMMO..OO",
    "OWO.OMXMMXMO.OWO",
    "OWWOOMMMMMMOOWWO",
    "OWWWOmMMMMmOWWWO",
    ".OWWWOmMMmOWWWO.",
    "..OWOOOmmOOOWO..",
    "...O..OOOO..O...",
    "................", "................", "................", "................",
]
MURCIELAGO_ABAJO = [
    "................", "................", "................",
    "......O..O......",
    ".....OMOOMO.....",
    "....OMMMMMMO....",
    "...OOMXMMXMOO...",
    "..OWWMMMMMMWWO..",
    ".OWWWOmMMmOWWWO.",
    "OWWWO.OmmO.OWWWO",
    "OWWO..OOOO..OWWO",
    "OWO..........OWO",
    "OO............OO",
    "................", "................", "................",
]
MURCIELAGO_DORMIDO = [
    "......O..O......",
    "......OOOO......",
    ".....OWWWWO.....",
    "....OWWMMWWO....",
    "....OWMmMmWO....",
    "....OWMMMMWO....",
    "....OWWMMWWO....",
    ".....OWWWWO.....",
    "......OMMO......",
    ".......OO.......",
] + ["................"] * 6


def tira(cuadros: list[Image.Image]) -> Image.Image:
    ancho, alto = cuadros[0].size
    hoja = Image.new("RGBA", (ancho * len(cuadros), alto), (0, 0, 0, 0))
    for i, cuadro in enumerate(cuadros):
        hoja.paste(cuadro, (i * ancho, 0), cuadro)
    return hoja


def main() -> None:
    salida = Path(sys.argv[1])
    for carpeta in ("caballero", "slime", "murcielago"):
        (salida / carpeta).mkdir(parents=True, exist_ok=True)

    quieto = dibujar(QUIETO, 24)
    salto = dibujar(SALTO, 24)
    caballero = {
        "quieto": [quieto, dibujar(QUIETO_2, 24)],
        "caminar": [dibujar(f, 24) for f in CAMINAR],
        "saltar": [salto],
        "caer": [capa_hacia_arriba(salto)],
        "doble_salto": [con_destellos(salto)],
        "dash": [dibujar(DASH, 24)],
        "atacar": [dibujar(f, 24) for f in ATAQUE],
        "herido": [tenido_rojo(quieto)],
        "muerto": [caido(quieto)],
    }
    slime = {"moverse": [dibujar(SLIME, 16), dibujar(SLIME_APLASTADO, 16)]}
    murcielago = {
        "dormido": [dibujar(MURCIELAGO_DORMIDO, 16)],
        "volar": [dibujar(MURCIELAGO_ARRIBA, 16), dibujar(MURCIELAGO_ABAJO, 16)],
    }
    for carpeta, animaciones in (("caballero", caballero), ("slime", slime), ("murcielago", murcielago)):
        for nombre, cuadros in animaciones.items():
            tira(cuadros).save(salida / carpeta / f"{carpeta}_{nombre}.png")

    # Lámina de revisión con todas las animaciones
    escala, margen = 6, 14
    filas = [(f"caballero: {n}", c) for n, c in caballero.items()] + \
            [(f"slime: {n}", c) for n, c in slime.items()] + [(f"murcielago: {n}", c) for n, c in murcielago.items()]
    alto_fila = 24 * escala + margen + 14
    lamina = Image.new("RGB", (4 * (24 * escala + margen) + margen + 170, len(filas) * alto_fila + margen), (46, 59, 50))
    pincel = ImageDraw.Draw(lamina)
    for i, (titulo, cuadros) in enumerate(filas):
        y = margen + i * alto_fila
        pincel.text((margen, y + 24 * escala // 2), titulo, fill=(244, 241, 232))
        for j, cuadro in enumerate(cuadros):
            grande = cuadro.resize((cuadro.width * escala, cuadro.height * escala), Image.NEAREST)
            x = 170 + margen + j * (24 * escala + margen)
            pincel.rectangle([x - 1, y - 1, x + 24 * escala, y + 24 * escala], outline=(90, 107, 94))
            lamina.paste(grande, (x, y + (24 - cuadro.height) * escala), grande)
    lamina.save(salida / "lamina_animaciones.png")
    print("hojas de sprites en", salida)


if __name__ == "__main__":
    main()
