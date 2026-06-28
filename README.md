<div align="center">

# 🧰 Caja de Herramientas

### Una app móvil que se siente como abrir una caja de herramientas real

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Material You](https://img.shields.io/badge/Material%20You-Dark-FFE285?logo=materialdesign&logoColor=3B2F00)](https://m3.material.io/)
[![Platforms](https://img.shields.io/badge/Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-supported-success)](#)

**7 herramientas · 6 APIs públicas · 6 sonidos sintetizados · 0 imágenes para los gráficos**

</div>

---

## ✨ ¿Qué hace especial esta app?

> No es una lista de menú. Es una **escena interactiva**: una caja roja cae del cielo sobre el banco de trabajo de un garaje, rebota, y al tocarla se abre desplegando un abanico de cartas — cada una con sonido propio, vibración háptica y transiciones cinemáticas.

```
       🧰 ← cae con gravedad real (Curves.bounceOut)
        ↓   thud × 3 (en cada rebote, volumen decreciente)
   ════════ ← banco de trabajo de madera
        ↓
      *clic* → tapa se abre con chirrido
        ↓
   🃏 🃏 🃏 🃏 🃏 🃏 🃏 ← 7 cartas en abanico
        ↓
     *tap*  → carta se expande hasta llenar la pantalla
```

---

## 🛠️ Las 7 herramientas

| | Herramienta | Qué hace | API |
|:---:|---|---|---|
| 👤 | **Predecir Género** | Predice género de un nombre con % de confianza | [genderize.io](https://genderize.io/) |
| 🎂 | **Predecir Edad** | Estima edad media de un nombre (Joven/Adulto/Anciano) | [agify.io](https://agify.io/) |
| 🎓 | **Universidades** | Lista universidades por país con dominios | [hipolabs](http://universities.hipolabs.com/) |
| 🌤️ | **Clima en RD** | Tiempo en Santo Domingo + 3 días de pronóstico | [open-meteo](https://open-meteo.com/) |
| ⚡ | **Pokémon** | Stats, tipos, sprite y grito del Pokémon | [pokeapi](https://pokeapi.co/) |
| 📰 | **Noticias WP** | Últimas 3 publicaciones del blog | [tecnologia21.com](https://tecnologia21.com) |
| ℹ️ | **Acerca de** | Contacto del desarrollador con enlaces vivos | — |

---

## 🎬 Cómo se siente — animaciones y feedback

| Momento | Visual | Sonido | Vibración |
|---|---|:---:|:---:|
| 🚀 Abre la app | Caja cae 2.2s con `bounceOut` | — | — |
| 🥁 **Rebote 1** | Toca el banco (impacto fuerte) | 🔊 `thud` 100% | 📳 Fuerte |
| 🥁 **Rebote 2** | Salto menor | 🔊 `thud` 55% | — |
| 🥁 **Rebote 3** | Asentamiento | 🔊 `thud` 28% | — |
| 👆 Tocas la caja | Tapa abre 750ms con `easeOutBack` | 🔊 `lid_open` | 📳 Medio |
| 🌟 Cartas salen | Abanico desplegándose en arco | 🔊 `fan_spread` | 📳 Suave |
| 🃏 Tocas carta | Carta se centra y agranda | 🔊 `card_tap` | 📳 Selección |
| 🚪 Tocas de nuevo | Carta se expande a pantalla completa | 🔊 `screen_open` | 📳 Suave |
| 🔒 Cierras la caja | Tapa baja, *clack* de madera | 🔊 `box_close` | 📳 Medio |

---

## 🎨 ¿Por qué se ve tan nítido? — Todo es vectorial

Los gráficos NO son PNGs. Se dibujan con **`CustomPainter`** (la API de Canvas de Flutter) — código matemático que genera la imagen en tiempo real:

```dart
// ejemplo: la tapa de la caja, en lugar de un PNG
final path = Path()
  ..moveTo(x1, y1)
  ..quadraticBezierTo(cx, cy, x2, y2)
  ..close();
canvas.drawPath(path, redGradientPaint);
```

| Elemento | Cómo se hizo |
|---|---|
| 🧰 **Caja roja** estilo URREA | `CustomPainter` con 7 tonos de rojo + gradientes + sombras |
| 🏚️ **Fondo del garaje** | `CustomPainter`: pared, techo de madera, viga, LED, pegboard con herramientas colgadas, gabinete, piso |
| 📱 **Mini-preview** dentro de cada carta | `Container` + `BoxDecoration` (app bar simulada + ícono en círculo dorado + filas falsas) |
| 🎯 **Íconos** | Material Icons (vectoriales) de Flutter |

**Beneficios:** nítido en cualquier DPI · APK más liviano · animable (la tapa abre porque es un `Path`, no un sprite) · tematizable.

---

## 🔊 ¿Y los sonidos? — Sintetizados con matemática

Los 6 WAV NO se descargaron. Se generaron con un script Python que escribe ondas muestra por muestra:

```python
# thud: golpe grave (caja cayendo)
tone = sin(2π · 70 · t) + sin(2π · 40 · t) · 0.6   # mezcla 70+40 Hz
noise = random() · 0.25                              # → simula el "golpe seco"
envelope = e^(-18·t)                                 # → decay rápido
sample = (tone + noise) · envelope · 0.65
```

| Sonido | Receta | Duración | Peso |
|---|---|:---:|:---:|
| `thud.wav` | Senos 70+40Hz + ruido + decay rápido | 300 ms | 12 KB |
| `lid_open.wav` | Barrido 200→700 Hz (chirrido) | 220 ms | 9 KB |
| `fan_spread.wav` | Barrido 800→220 Hz (whoosh) | 280 ms | 12 KB |
| `card_tap.wav` | Seno 1000 Hz, decay ultra-corto | 65 ms | 2 KB |
| `screen_open.wav` | Barrido 1200→1800 Hz (campanilla) | 140 ms | 6 KB |
| `box_close.wav` | Barrido 280→90 Hz + armónico + ruido | 180 ms | 7 KB |

**Total: ~47 KB para los 6 sonidos.** El script (`assets/audio/gen_sounds.py`) es la receta — si quieres ajustar tonos, editas la fórmula y regeneras.

> ⚠️ Python NO se ejecuta en tu celular. Es solo la herramienta que creó los assets (como Photoshop crearía un PNG). La app que corre en el dispositivo es **100% Dart/Flutter**.

---

## 🏗️ Arquitectura del proyecto

```mermaid
flowchart TD
    A(["👤 Usuario"]):::user
    B["🎬 Pantallas"]:::screens
    C["🧩 Widgets"]:::widgets
    D["⚙️ Servicios"]:::services

    A ==> B
    B ==> C
    C ==> D
    D ==> Assets[("📦 Assets locales")]:::assets
    D ==> APIs{{"🌍 APIs externas"}}:::apihub

    APIs --> API1["🌐 genderize.io"]:::api
    APIs --> API2["🌐 agify.io"]:::api
    APIs --> API3["🌐 hipolabs"]:::api
    APIs --> API4["🌐 open-meteo"]:::api
    APIs --> API5["🌐 pokeapi"]:::api
    APIs --> API6["🌐 tecnologia21"]:::api

    classDef user fill:#FFE285,color:#000,stroke:#3B2F00,stroke-width:3px
    classDef screens fill:#DE3B2E,color:#fff,stroke:#7E120B,stroke-width:2px
    classDef widgets fill:#2A3540,color:#fff,stroke:#7BA7E3,stroke-width:2px
    classDef services fill:#2A4029,color:#fff,stroke:#9CD67D,stroke-width:2px
    classDef assets fill:#3A2E1A,color:#fff,stroke:#FFE285,stroke-width:2px
    classDef apihub fill:#333535,color:#fff,stroke:#CFC6AF,stroke-width:2px
    classDef api fill:#1E2A30,color:#fff,stroke:#5A9BB8,stroke-width:1.5px

    linkStyle 0,1,2,3,4 stroke:#FFE285,stroke-width:2px
    linkStyle 5,6,7,8,9,10 stroke:#5A9BB8,stroke-width:1.5px,stroke-dasharray:3 3
```

> 🟡 **Líneas continuas doradas** = dentro de la app (datos que fluyen capa por capa)
> 🔵 **Líneas punteadas azules** = peticiones HTTP a internet

<details>
<summary><b>📂 Ver árbol de archivos completo</b></summary>

```
📁 Tarea5/
│
├── 📄 README.md                        ← este archivo
├── 🎨 DESIGN.md                        ← sistema de diseño
├── 📦 toolbox.apk                      ← APK release (49 MB)
│
└── 📱 toolbox_app/                     ← Proyecto Flutter
    │
    ├── 📄 pubspec.yaml                 ← dependencias y assets
    │
    ├── 🖼️  assets/
    │   ├── images/yeison.jpg           ← foto (único raster)
    │   └── audio/                      ← 6 WAVs + gen_sounds.py
    │
    └── 📂 lib/
        ├── 🚀 main.dart                ← entry point
        │
        ├── 🎨 theme/
        │   └── app_theme.dart          ← colores, AppCard, AppChip
        │
        ├── 🔊 services/
        │   └── sound_service.dart      ← singleton audio + háptica
        │
        ├── 🧩 widgets/
        │   ├── toolbox.dart            ← caja roja vectorial
        │   ├── garage_background.dart  ← garaje vectorial
        │   ├── screen_preview.dart     ← preview en cartas
        │   ├── appear.dart             ← fade + slide
        │   └── anim.dart               ← CountUp, PopIn, Floating
        │
        └── 📂 screens/                 ← 1 archivo por herramienta
            ├── home_screen.dart        ← 🎬 escena animada
            ├── gender_screen.dart      ← 👤
            ├── age_screen.dart         ← 🎂
            ├── universities_screen.dart← 🎓
            ├── weather_screen.dart     ← 🌤️
            ├── pokemon_screen.dart     ← ⚡
            ├── wordpress_screen.dart   ← 📰
            └── about_screen.dart       ← ℹ️
```

</details>

---

## 🔄 Flujo de la aplicación

```mermaid
flowchart TD
    A(["📱 1 · Abres la app"]):::startNode
    B["🧰 2 · La caja roja cae del cielo<br/><sub>rebota 3 veces sobre el banco · 🔊 thud × 3</sub>"]:::mainNode
    C["👆 3 · Tocas la caja<br/><sub>la tapa se abre con un chirrido · 🔊 lid_open</sub>"]:::mainNode
    D["🃏 4 · 7 cartas salen en abanico<br/><sub>una herramienta por carta · 🔊 fan_spread</sub>"]:::mainNode
    E["👆 5 · Eliges una carta<br/><sub>se centra al tocarla · 2do toque la expande</sub>"]:::mainNode
    F(["🛠️ 6 · La herramienta llena la pantalla"]):::finishNode

    A ==> B ==> C ==> D ==> E ==> F

    classDef startNode fill:#FFE285,color:#3B2F00,stroke:#3B2F00,stroke-width:3px
    classDef mainNode fill:#282A2B,color:#E2E2E2,stroke:#FFE285,stroke-width:1.5px
    classDef finishNode fill:#DE3B2E,color:#fff,stroke:#7E120B,stroke-width:3px

    linkStyle 0,1,2,3,4 stroke:#FFE285,stroke-width:2.5px
```

---

## 📦 Dependencias

| Paquete | Para qué |
|---|---|
| [`http`](https://pub.dev/packages/http) | Llamadas GET a las 6 APIs |
| [`url_launcher`](https://pub.dev/packages/url_launcher) | Abrir GitHub/LinkedIn/email/teléfono desde "Acerca de" |
| [`audioplayers`](https://pub.dev/packages/audioplayers) | Reproducir los WAV con control de volumen |
| [`cached_network_image`](https://pub.dev/packages/cached_network_image) | Cache de sprites de Pokémon |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | Tipografía Inter consistente |
| [`animations`](https://pub.dev/packages/animations) | `OpenContainer` (transición carta → pantalla) |
| [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) | Generar el ícono de la app |

---

## 🚀 Cómo correrlo

```bash
# Clonar
git clone https://github.com/yeisondev001/Tarea5.git
cd Tarea5/toolbox_app

# Dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# O construir APK release (Android)
flutter build apk --release
```

> 💡 **Para web:** usar `flutter build web --release` y servir `build/web` con cualquier HTTP server. El modo debug en Chrome demora 1-2 minutos en cargar CanvasKit la primera vez — release es instantáneo.

---

## 🧠 Decisiones técnicas y problemas resueltos

| Reto | Solución |
|---|---|
| 🐌 Modo debug web tardaba 2 min en cargar | Build release + Python HTTP server |
| 💥 APK fallaba con path "Introducción al desarrollo..." | Trabajo desde `C:\tarea6` (path ASCII) y sync con `robocopy` |
| 📸 La foto cortaba la frente | `ClipOval` + `alignment: Alignment(0, -0.6)` |
| 🔗 URLs largas desbordaban el "Acerca de" | Texto corto + URL real solo al tap |
| 🌡️ Temperatura grande desbordaba el card | `FittedBox(fit: BoxFit.scaleDown)` |
| 🎞️ Lag con fondo repintándose 60 FPS | `RepaintBoundary` alrededor de `GarageBackground` |
| 🔊 Sonido sonaba solo al final del rebote | Listener detecta 3 momentos clave (`t=0.36/0.73/0.91`) y dispara `thud` con volumen decreciente |

---

## 👤 Autor

**Yeison Gregori Rojas Henríquez**
Matrícula: `20241822`

- 🐙 GitHub: [@yeisondev001](https://github.com/yeisondev001)
- 💼 LinkedIn: [yeison-rojas-henriquez](https://www.linkedin.com/in/yeison-rojas-henriquez)
- 📧 Email: yeisonrojass03@gmail.com
- 📱 +1 (829) 801-9374

> *Tarea 6 — Introducción al Desarrollo de Aplicaciones Móviles*

---

<div align="center">

**100% Flutter · 100% Vectorial · 100% Sintetizado**

🧰 Hecho con cariño y mucho `CustomPainter` 🧰

</div>
