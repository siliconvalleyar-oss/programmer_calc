# BioGol App

App Flutter educativa sobre Sistema Nervioso con temática de fútbol mundialista.

## Project structure

```
BioGol/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app_theme.dart               # Paleta minimalista + botones reutilizables
│   ├── home_screen.dart             # Home grid + bottom nav + persistencia puntos por id
│   ├── model/
│   │   └── data.dart                # Modelos + trivia (40 preg) + demo (10 fáciles)
│   ├── services/
│   │   └── audio_service.dart       # Reproducción + feedback evolutivo por racha
│   └── screens/
│       ├── modelo_screen.dart       # Círculos E-R-P-R-E + penal secuencial animado
│       ├── situaciones_screen.dart  # 20 flashcards táctiles
│       ├── trivia_screen.dart       # Trivia V/F + demo + resultados + feedback audio
│       ├── reaccion_screen.dart     # Test reacción 5 rondas, retorna promedio
│       ├── color_test_screen.dart   # Test colores: ver color 300ms, elegir entre 4
│       ├── sonido_test_screen.dart  # Test sonidos: identificar grave/media/aguda
│       ├── circuito_screen.dart     # 5 estaciones sensoriales
│       ├── diploma_screen.dart      # Diploma + QR + WhatsApp share + Campeón Estímulos
│       ├── ranking_screen.dart      # Leaderboard ordenado por puntosTotales
│       ├── usuarios_screen.dart     # CRUD + 70+ países + email/telefono + bandera custom
│       └── admin_screen.dart        # Paletas, fontSize, timer, audio mapping
├── assets/
│   ├── audio/                       # 7 MP3s base + lugar para gol,golazo,genio,etc
│   └── images/logo.png
├── APK/
│   └── BioGol.apk
├── .opencode/skills/biogol-app.md
├── opencode.jsonc
└── pubspec.yaml
```

## Key conventions

- **StatefulWidget** para todas las screens
- **Navigator.push** con `await` para recibir resultados de juegos
- **Bottom nav** scrollable 8 items: Inicio, Colores, Sonidos, Trivia, Reacción, Demo, Ranking, Admin
- **Home grid** (2 cols, TweenAnimationBuilder): Modelo, Situaciones, Trivia, Reacción, Colores, Sonidos, Circuito, Diploma, Ranking, Usuarios, Admin
- **Persistencia**: juegos retornan resultado → `home_screen` acumula en `_state` → `_guardarEstado()` persiste Usuario a SharedPreferences (match por `id` único)
- **Puntos**: `Usuario.puntosTotales = puntos + colorTestPuntos + sonidoTestPuntos`
- **User check**: `_checkUser()` exige `usuarioActivo != null` antes de juegos (Demo no requiere)
- **audio**: `audioplayers`, `AssetSource('audio/$filename')`, `AudioService` singleton
- **Usuario.id**: generado como `DateTime.now().microsecondsSinceEpoch.toString()`
- **Campeón de los Estímulos**: badge dorado en diploma cuando usuario completó Trivia + Reacción + Colores + Sonidos

## Tests de juego

| Juego | Mecánica | Retorno |
|-------|----------|---------|
| Trivia | 10 preg V/F, puntos por velocidad + racha | `TriviaResult(puntos, correctas, incorrectas, rachaMax)` |
| Reacción | 5 rondas tocar botón al cambiar color | `int` promedio ms |
| Colores | 10 rondas: color visible 300ms, elegir entre 4 opciones | `int` puntos acumulados |
| Sonidos | 10 rondas: identificar tono grave/media/aguda | `int` puntos acumulados |

Puntos en Colores/Sonidos: `max(10, 100 - ms/10)` por acierto, `-20` por error.

## Evolución de audio (trivia)

| Situación | Racha | Audio |
|-----------|-------|-------|
| Correcta | 1-2 | `correcto.mp3`, `gol.mp3`, `golazo.mp3`, `perfecto.mp3` (aleatorio) |
| Correcta | 3-4 | `vamosbien.mp3` |
| Correcta | 5-7 | `genio.mp3` |
| Correcta | 8+ | `crack.mp3` |
| 100% 10+ preg | — | `larompiste.mp3` |
| Incorrecta | cualquier | `afuera.mp3`, `miratecomo.mp3`, `mejora.mp3` |
| < 50% aciertos | 5+ preg | `debesestudiar.mp3`, `entrenaconlibros.mp3` |

## Navegación

- **Bottom nav** (scrollable): Inicio, Colores, Sonidos, Trivia, Reacción, Demo, Ranking, Admin
- **Home grid** (2 cols): Modelo, Situaciones, Trivia, Reacción, Colores, Sonidos, Circuito, Diploma, Ranking, Usuarios, Admin
- Demo no requiere usuario activo, usa preguntas fáciles con 20s por respuesta

## Custom flag (Usuarios)

- Al seleccionar "Personalizado" en el dropdown de países:
  - Campo para nombre de la bandera
  - Botones +/− para agregar/quitar franjas (1-4)
  - Selector de color por franja (popup 12 colores)
  - Reordenar franjas arrastrando (ReorderableListView)
  - Vista previa en vivo
  - Formato guardado: `CUSTOM:nombre:#color1:#color2:...:#colorN`

## Países disponibles

70+ países incluyendo todos los clasificados al Mundial 2026 + opción Personalizado.

## Build commands

```bash
flutter pub get
flutter analyze
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk APK/BioGol.apk
```

## Audio files needed

Además de los 7 MP3 base, crear:
- `gol.mp3`, `golazo.mp3`, `perfecto.mp3`, `vamosbien.mp3`
- `genio.mp3`, `crack.mp3`, `larompiste.mp3`
- `afuera.mp3`, `miratecomo.mp3`, `mejora.mp3`
- `debesestudiar.mp3`, `entrenaconlibros.mp3`

## Usuario fields

```dart
id, nombre, edad, alias, pais, email, telefono,
puntos, aciertos, racha, rachaMax, reaccionPromedio,
colorTestPuntos, sonidoTestPuntos, fecha
```
